namespace HelianzApi.Models;

public class QueueItem
{
    public long AptNum { get; set; }
    public long PatNum { get; set; }
    public string PatientName { get; set; } = string.Empty;
    public string QueueLabel { get; set; } = string.Empty;
    public long OpNum { get; set; }
    public string OpName { get; set; } = string.Empty;
    public long ProvNum { get; set; }
    public string ProvName { get; set; } = string.Empty;
    public long ClinicNum { get; set; }
    public string ClinicName { get; set; } = string.Empty;
    public int AptStatus { get; set; }
    public DateTime? DateTimeArrived { get; set; }
    public DateTime? DateTimeSeated { get; set; }
    public DateTime? DateTimeDismissed { get; set; }
    public int MinutesWaiting { get; set; }
    public string StatusText { get; set; } = "Waiting"; // Waiting, Calling, InRoom, Completed
    public DateTime? LastCalledAt { get; set; }
    public string Note { get; set; } = string.Empty;
}

public class RoomStatus
{
    public long OperatoryNum { get; set; }
    public string OpName { get; set; } = string.Empty;
    public string Abbrev { get; set; } = string.Empty;
    public long ClinicNum { get; set; }
    public long ProvNum { get; set; }
    public string ProvName { get; set; } = string.Empty;
    public string Status { get; set; } = "Available"; // Available, Serving, Break
    public QueueItem? CurrentPatient { get; set; }
}

public class QueueDisplayData
{
    public long ClinicNum { get; set; }
    public string ClinicName { get; set; } = string.Empty;
    public string ClinicAddress { get; set; } = string.Empty;
    public string ClinicPhone { get; set; } = string.Empty;
    public QueueItem? CurrentCalling { get; set; }
    public List<QueueItem> RecentCalls { get; set; } = new();
    public List<RoomStatus> Rooms { get; set; } = new();
    public List<QueueItem> WaitingList { get; set; } = new();
    public string MarqueeText { get; set; } = string.Empty;
    public List<VideoItem> Playlist { get; set; } = new();
    public DateTime Timestamp { get; set; } = DateTime.Now;
}

public class VideoItem
{
    public string Id { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Type { get; set; } = "youtube"; // youtube, mp4
    public string Url { get; set; } = string.Empty;
    public string Thumbnail { get; set; } = string.Empty;
    public int DurationSeconds { get; set; }
}

public class CallPatientRequest
{
    public long AptNum { get; set; }
    public long? OpNum { get; set; }
    public long? ProvNum { get; set; }
    public long ClinicNum { get; set; }
}

public class PatientArrivalRequest
{
    public long AptNum { get; set; }
}
