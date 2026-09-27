using System.Collections.Concurrent;
using System.Data;
using Dapper;
using HelianzApi.Data;
using HelianzApi.Models;

namespace HelianzApi.Services;

public class QueueService
{
    private readonly DatabaseConnectionFactory _db;
    
    // In-memory cache of latest called patient per clinic for instant real-time TV display
    private static readonly ConcurrentDictionary<long, QueueItem> _lastCalledPerClinic = new();
    private static readonly ConcurrentDictionary<long, List<QueueItem>> _recentCallsPerClinic = new();

    public QueueService(DatabaseConnectionFactory db) => _db = db;

    public async Task<QueueDisplayData> GetDisplayDataAsync(long clinicNum)
    {
        using var conn = _db.CreateConnection();

        // 1. Clinic Info
        var clinic = await conn.QueryFirstOrDefaultAsync<ClinicInfo>(@"
            SELECT ClinicNum, Description, Address, City, Phone
            FROM clinic
            WHERE ClinicNum = @ClinicNum", new { ClinicNum = clinicNum });

        string clinicName = clinic?.Description ?? "";
        if (string.IsNullOrWhiteSpace(clinicName))
        {
            var practiceTitle = await conn.QueryFirstOrDefaultAsync<string>(
                "SELECT ValueString FROM preference WHERE PrefName = 'PracticeTitle'");
            clinicName = !string.IsNullOrWhiteSpace(practiceTitle) ? practiceTitle : "D'SMILE Dental Care";
        }
        string clinicAddress = clinic?.Address ?? "Pusat Layanan Kesehatan Gigi - Klaten";
        string clinicPhone = clinic?.Phone ?? "";

        // 2. Operatories / Doctor Rooms
        var operatorySql = @"
            SELECT o.OperatoryNum, o.OpName, o.Abbrev, o.ClinicNum,
                   o.ProvDentist AS ProvNum,
                   COALESCE(NULLIF(p.Abbr, ''), NULLIF(CONCAT(p.FName, ' ', p.LName), ' ')) AS ProvName
            FROM operatory o
            LEFT JOIN provider p ON o.ProvDentist = p.ProvNum
            WHERE o.IsHidden = 0 " +
            (clinicNum > 0 ? "AND (o.ClinicNum = @ClinicNum OR o.ClinicNum = 0)" : "") +
            " ORDER BY o.ItemOrder, o.OperatoryNum";

        var roomsRaw = (await conn.QueryAsync(operatorySql, new { ClinicNum = clinicNum })).ToList();

        // 3. Today's active appointments (Arrived or Scheduled today)
        var apptSql = @"
            SELECT a.AptNum, a.PatNum,
                   CONCAT(p.FName, ' ', p.LName) AS PatientName,
                   a.QueueLabel, a.Op AS OpNum, o.OpName,
                   a.ProvNum, COALESCE(NULLIF(prov.Abbr, ''), NULLIF(CONCAT(prov.FName, ' ', prov.LName), ' ')) AS ProvName,
                   a.ClinicNum, c.Description AS ClinicName,
                   a.AptStatus, a.AptDateTime,
                   a.DateTimeArrived, a.DateTimeSeated, a.DateTimeDismissed,
                   a.Note
            FROM appointment a
            JOIN patient p ON a.PatNum = p.PatNum
            LEFT JOIN operatory o ON a.Op = o.OperatoryNum
            LEFT JOIN provider prov ON a.ProvNum = prov.ProvNum
            LEFT JOIN clinic c ON a.ClinicNum = c.ClinicNum
            WHERE a.AptDateTime >= CURDATE() AND a.AptDateTime < DATE_ADD(CURDATE(), INTERVAL 1 DAY)
              AND a.AptStatus NOT IN (5, 6) " +
            (clinicNum > 0 ? "AND (a.ClinicNum = @ClinicNum OR a.ClinicNum = 0)" : "") +
            " ORDER BY a.DateTimeArrived ASC, a.AptDateTime ASC";

        var appointments = (await conn.QueryAsync(apptSql, new { ClinicNum = clinicNum })).ToList();

        var waitingList = new List<QueueItem>();
        var activeInRoom = new Dictionary<long, QueueItem>(); // Key = OpNum

        var now = DateTime.Now;

        foreach (var row in appointments)
        {
            DateTime? dtArrived = SafeDateTime(row.DateTimeArrived);
            DateTime? dtSeated = SafeDateTime(row.DateTimeSeated);
            DateTime? dtDismissed = SafeDateTime(row.DateTimeDismissed);

            int minutesWaiting = 0;
            if (dtArrived.HasValue)
            {
                minutesWaiting = (int)Math.Max(0, (now - dtArrived.Value).TotalMinutes);
            }

            var item = new QueueItem
            {
                AptNum = row.AptNum,
                PatNum = row.PatNum,
                PatientName = row.PatientName ?? "Pasien",
                QueueLabel = string.IsNullOrWhiteSpace(row.QueueLabel) ? $"#{row.AptNum}" : row.QueueLabel,
                OpNum = row.OpNum ?? 0,
                OpName = row.OpName ?? "Ruang Periksa",
                ProvNum = row.ProvNum ?? 0,
                ProvName = row.ProvName ?? "Dokter Gigi",
                ClinicNum = row.ClinicNum ?? 0,
                ClinicName = row.ClinicName ?? clinicName,
                AptStatus = row.AptStatus,
                DateTimeArrived = dtArrived,
                DateTimeSeated = dtSeated,
                DateTimeDismissed = dtDismissed,
                MinutesWaiting = minutesWaiting,
                Note = row.Note ?? ""
            };

            // If arrived and not yet seated or dismissed -> In Waiting Room
            if (dtArrived.HasValue && !dtSeated.HasValue && !dtDismissed.HasValue)
            {
                item.StatusText = "Waiting";
                waitingList.Add(item);
            }
            // If seated and not yet dismissed -> In Room
            else if (dtSeated.HasValue && !dtDismissed.HasValue)
            {
                item.StatusText = "InRoom";
                if (item.OpNum > 0 && !activeInRoom.ContainsKey(item.OpNum))
                {
                    activeInRoom[item.OpNum] = item;
                }
            }
        }

        // 4. Build RoomStatus list
        var defaultDoctors = new[] { "drg. Prima, Sp.Ort", "drg. Kristanti, Sp.KG", "drg. Lintang", "drg. Afina, Sp.Ort" };
        var roomList = new List<RoomStatus>();
        int doctorIdx = 0;
        foreach (var r in roomsRaw)
        {
            long opNum = r.OperatoryNum;
            string provName = (string?)r.ProvName ?? "";
            if (string.IsNullOrWhiteSpace(provName))
            {
                provName = defaultDoctors[doctorIdx % defaultDoctors.Length];
                doctorIdx++;
            }

            var room = new RoomStatus
            {
                OperatoryNum = opNum,
                OpName = r.OpName ?? $"Room {opNum}",
                Abbrev = r.Abbrev ?? "",
                ClinicNum = r.ClinicNum ?? 0,
                ProvNum = r.ProvNum ?? 0,
                ProvName = provName,
                Status = "Available",
                CurrentPatient = null
            };

            if (activeInRoom.TryGetValue(opNum, out var patInRoom))
            {
                room.Status = "Serving";
                room.CurrentPatient = patInRoom;
                if (!string.IsNullOrEmpty(patInRoom.ProvName))
                {
                    room.ProvName = patInRoom.ProvName;
                }
            }

            roomList.Add(room);
        }

        // 5. Current Calling patient
        _lastCalledPerClinic.TryGetValue(clinicNum, out var currentCalling);
        _recentCallsPerClinic.TryGetValue(clinicNum, out var recentCalls);

        return new QueueDisplayData
        {
            ClinicNum = clinicNum,
            ClinicName = clinicName,
            ClinicAddress = clinicAddress,
            ClinicPhone = clinicPhone,
            CurrentCalling = currentCalling,
            RecentCalls = recentCalls ?? new List<QueueItem>(),
            Rooms = roomList,
            WaitingList = waitingList,
            MarqueeText = "Selamat Datang di Helianz Dental Care • Harap perhatikan nomor antrian pada layar • Jaga kebersihan gigi Anda dengan kontrol berkala setiap 6 bulan • Terima kasih atas kunjungan Anda.",
            Playlist = GetDefaultPlaylist(),
            Timestamp = DateTime.Now
        };
    }

    public async Task<QueueItem?> CallPatientAsync(CallPatientRequest req)
    {
        using var conn = _db.CreateConnection();

        var appt = await conn.QueryFirstOrDefaultAsync<dynamic>(@"
            SELECT a.AptNum, a.PatNum, CONCAT(p.FName, ' ', p.LName) AS PatientName,
                   a.QueueLabel, a.Op AS OpNum, o.OpName,
                   a.ProvNum, CONCAT(prov.FName, ' ', prov.LName) AS ProvName,
                   a.ClinicNum, c.Description AS ClinicName,
                   a.AptDateTime, a.DateTimeArrived
            FROM appointment a
            JOIN patient p ON a.PatNum = p.PatNum
            LEFT JOIN operatory o ON a.Op = o.OperatoryNum
            LEFT JOIN provider prov ON a.ProvNum = prov.ProvNum
            LEFT JOIN clinic c ON a.ClinicNum = c.ClinicNum
            WHERE a.AptNum = @AptNum", new { req.AptNum });

        if (appt == null) return null;

        // If OpNum or ProvNum specified in request, override
        long opNum = req.OpNum.HasValue && req.OpNum.Value > 0 ? req.OpNum.Value : (long)(appt.OpNum ?? 0);
        string opName = appt.OpName ?? "Ruang Periksa";
        if (req.OpNum.HasValue && req.OpNum.Value > 0)
        {
            var opInfo = await conn.QueryFirstOrDefaultAsync<string>(
                "SELECT OpName FROM operatory WHERE OperatoryNum = @OpNum", new { OpNum = req.OpNum.Value });
            if (!string.IsNullOrEmpty(opInfo)) opName = opInfo;
        }

        string provName = appt.ProvName ?? "Dokter Gigi";
        if (req.ProvNum.HasValue && req.ProvNum.Value > 0)
        {
            var provInfo = await conn.QueryFirstOrDefaultAsync<string>(
                "SELECT CONCAT(FName, ' ', LName) FROM provider WHERE ProvNum = @ProvNum", new { ProvNum = req.ProvNum.Value });
            if (!string.IsNullOrEmpty(provInfo)) provName = provInfo;
        }

        var queueItem = new QueueItem
        {
            AptNum = appt.AptNum,
            PatNum = appt.PatNum,
            PatientName = appt.PatientName,
            QueueLabel = string.IsNullOrWhiteSpace(appt.QueueLabel) ? $"#{appt.AptNum}" : appt.QueueLabel,
            OpNum = opNum,
            OpName = opName,
            ProvNum = req.ProvNum ?? (long)(appt.ProvNum ?? 0),
            ProvName = provName,
            ClinicNum = req.ClinicNum > 0 ? req.ClinicNum : (long)(appt.ClinicNum ?? 0),
            ClinicName = appt.ClinicName ?? "Helianz Dental Care",
            StatusText = "Calling",
            LastCalledAt = DateTime.Now
        };

        // Record in cache
        long clinicKey = queueItem.ClinicNum;
        _lastCalledPerClinic[clinicKey] = queueItem;
        _lastCalledPerClinic[0] = queueItem; // Also update default/global

        var recent = _recentCallsPerClinic.GetOrAdd(clinicKey, _ => new List<QueueItem>());
        lock (recent)
        {
            recent.RemoveAll(x => x.AptNum == queueItem.AptNum);
            recent.Insert(0, queueItem);
            if (recent.Count > 10) recent.RemoveAt(recent.Count - 1);
        }

        return queueItem;
    }

    public async Task<bool> SetArrivedAsync(long aptNum)
    {
        using var conn = _db.CreateConnection();
        var rows = await conn.ExecuteAsync(@"
            UPDATE appointment
            SET DateTimeArrived = NOW()
            WHERE AptNum = @AptNum", new { AptNum = aptNum });
        return rows > 0;
    }

    public async Task<bool> SetSeatedAsync(long aptNum, long? opNum = null)
    {
        using var conn = _db.CreateConnection();
        string sql = opNum.HasValue && opNum.Value > 0
            ? "UPDATE appointment SET DateTimeSeated = NOW(), Op = @OpNum WHERE AptNum = @AptNum"
            : "UPDATE appointment SET DateTimeSeated = NOW() WHERE AptNum = @AptNum";

        var rows = await conn.ExecuteAsync(sql, new { AptNum = aptNum, OpNum = opNum });
        return rows > 0;
    }

    public async Task<bool> SetDismissedAsync(long aptNum)
    {
        using var conn = _db.CreateConnection();
        var rows = await conn.ExecuteAsync(@"
            UPDATE appointment
            SET DateTimeDismissed = NOW(), AptStatus = 2
            WHERE AptNum = @AptNum", new { AptNum = aptNum });
        return rows > 0;
    }

    public List<VideoItem> GetDefaultPlaylist()
    {
        return new List<VideoItem>
        {
            new()
            {
                Id = "v1",
                Title = "Cara Menyikat Gigi yang Benar (Proper Toothbrushing)",
                Type = "youtube",
                Url = "https://www.youtube.com/watch?v=xm9c5HAUBpY",
                Thumbnail = "https://img.youtube.com/vi/xm9c5HAUBpY/hqdefault.jpg",
                DurationSeconds = 180
            },
            new()
            {
                Id = "v2",
                Title = "Pentingnya Scaling Karang Gigi 6 Bulan Sekali",
                Type = "youtube",
                Url = "https://www.youtube.com/watch?v=kYv9Z8F9M6c",
                Thumbnail = "https://img.youtube.com/vi/kYv9Z8F9M6c/hqdefault.jpg",
                DurationSeconds = 210
            },
            new()
            {
                Id = "v3",
                Title = "Edukasi Perawatan Kawat Gigi (Orthodontic Care)",
                Type = "youtube",
                Url = "https://www.youtube.com/watch?v=t1nRM4X3y4M",
                Thumbnail = "https://img.youtube.com/vi/t1nRM4X3y4M/hqdefault.jpg",
                DurationSeconds = 240
            },
            new()
            {
                Id = "v4",
                Title = "Tips Menjaga Kesehatan Gigi dan Gusi Anak",
                Type = "youtube",
                Url = "https://www.youtube.com/watch?v=J8n0j8QG7w4",
                Thumbnail = "https://img.youtube.com/vi/J8n0j8QG7w4/hqdefault.jpg",
                DurationSeconds = 195
            }
        };
    }

    private static DateTime? SafeDateTime(object? val)
    {
        if (val == null || val is DBNull) return null;
        if (val is DateTime dt) return dt.Year > 1880 ? dt : null;
        if (val is MySqlConnector.MySqlDateTime mdt && mdt.IsValidDateTime)
        {
            try
            {
                var d = mdt.GetDateTime();
                return d.Year > 1880 ? d : null;
            }
            catch { return null; }
        }
        if (DateTime.TryParse(val.ToString(), out var parsed) && parsed.Year > 1880)
        {
            return parsed;
        }
        return null;
    }
}
