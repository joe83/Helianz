# Seed today's demo appointments in helianz_klt
$MySqlCmd = "mysql"
$Db = "helianz_klt"
$User = "root"
$Pass = "J0k0m4r0k3@"

$Sql = @"
-- Clear today's demo appointments
DELETE FROM appointment WHERE DATE(AptDateTime) = CURDATE();

-- Insert Seated Patients (Currently In Rooms)
INSERT INTO appointment (
    PatNum, AptStatus, Op, ProvNum, AptDateTime, Pattern, Note,
    Confirmed, IsNewPatient, ClinicNum, DateTimeArrived, DateTimeSeated, QueueLabel
) VALUES
(9007, 1, 1, 1, NOW(), '///////', 'Kontrol Behel / Ortho', 1, 0, 0, NOW() - INTERVAL 35 MINUTE, NOW() - INTERVAL 10 MINUTE, 'A-001'),
(9008, 1, 2, 20, NOW(), '///////', 'Perawatan Saluran Akar (PSA)', 1, 0, 0, NOW() - INTERVAL 25 MINUTE, NOW() - INTERVAL 5 MINUTE, 'B-001');

-- Insert Waiting Room Patients (Arrived and waiting)
INSERT INTO appointment (
    PatNum, AptStatus, Op, ProvNum, AptDateTime, Pattern, Note,
    Confirmed, IsNewPatient, ClinicNum, DateTimeArrived, QueueLabel
) VALUES
(9009, 1, 1, 1, NOW() + INTERVAL 20 MINUTE, '///////', 'Pemasangan Bracket Baru', 1, 0, 0, NOW() - INTERVAL 18 MINUTE, 'A-002'),
(9010, 1, 2, 20, NOW() + INTERVAL 30 MINUTE, '///////', 'Tambal Komposit Gigi Depan', 1, 0, 0, NOW() - INTERVAL 12 MINUTE, 'B-002'),
(9011, 1, 3, 5, NOW() + INTERVAL 40 MINUTE, '///////', 'Scaling & Pembersihan Karang Gigi', 1, 0, 0, NOW() - INTERVAL 8 MINUTE, 'C-001'),
(9012, 1, 1, 1, NOW() + INTERVAL 50 MINUTE, '///////', 'Kontrol Kawat Gigi Rutin', 1, 0, 0, NOW() - INTERVAL 4 MINUTE, 'A-003'),
(9014, 1, 2, 20, NOW() + INTERVAL 60 MINUTE, '///////', 'Konsultasi Gigi Sensitif', 1, 0, 0, NOW() - INTERVAL 1 MINUTE, 'B-003');

SELECT 'Demo appointments successfully seeded in helianz_klt' AS Status;
SELECT AptNum, PatNum, Op, ProvNum, QueueLabel, DateTimeArrived, DateTimeSeated FROM appointment WHERE DATE(AptDateTime) = CURDATE();
"@

$Sql | & $MySqlCmd -u $User "-p$Pass" -D $Db
