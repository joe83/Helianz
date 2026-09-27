import { Router, Request, Response } from 'express';
import pool from '../config/database';

const router = Router();

let lastCalled: any = null;

router.get('/display', async (req: Request, res: Response) => {
  try {
    const clinicNum = Number(req.query.clinicNum || 0);

    // 1. Clinic
    const [clinicRows]: any = await pool.query(
      'SELECT ClinicNum, Description, Address, Phone FROM clinic WHERE ClinicNum = ?',
      [clinicNum]
    );
    const clinic = clinicRows[0] || {};
    const clinicName = clinic.Description || 'Helianz Dental Care';
    const clinicAddress = clinic.Address || 'Pusat Layanan Kesehatan Gigi';

    // 2. Operatories
    let opSql = `
      SELECT o.OperatoryNum, o.OpName, o.Abbrev, o.ClinicNum,
             o.ProvDentist AS ProvNum,
             CONCAT(p.FName, ' ', p.LName) AS ProvName
      FROM operatory o
      LEFT JOIN provider p ON o.ProvDentist = p.ProvNum
      WHERE o.IsHidden = 0
    `;
    const opParams: any[] = [];
    if (clinicNum > 0) {
      opSql += ' AND (o.ClinicNum = ? OR o.ClinicNum = 0)';
      opParams.push(clinicNum);
    }
    opSql += ' ORDER BY o.ItemOrder, o.OperatoryNum';
    const [opRows]: any = await pool.query(opSql, opParams);

    // 3. Appointments today
    let apptSql = `
      SELECT a.AptNum, a.PatNum,
             CONCAT(p.FName, ' ', p.LName) AS PatientName,
             a.QueueLabel, a.Op AS OpNum, o.OpName,
             a.ProvNum, CONCAT(prov.FName, ' ', prov.LName) AS ProvName,
             a.ClinicNum, a.AptStatus, a.AptDateTime,
             a.DateTimeArrived, a.DateTimeSeated, a.DateTimeDismissed
      FROM appointment a
      JOIN patient p ON a.PatNum = p.PatNum
      LEFT JOIN operatory o ON a.Op = o.OperatoryNum
      LEFT JOIN provider prov ON a.ProvNum = prov.ProvNum
      WHERE a.AptDateTime >= CURDATE() AND a.AptDateTime < DATE_ADD(CURDATE(), INTERVAL 1 DAY)
        AND a.AptStatus NOT IN (5, 6)
    `;
    const apptParams: any[] = [];
    if (clinicNum > 0) {
      apptSql += ' AND (a.ClinicNum = ? OR a.ClinicNum = 0)';
      apptParams.push(clinicNum);
    }
    apptSql += ' ORDER BY a.DateTimeArrived ASC, a.AptDateTime ASC';
    const [apptRows]: any = await pool.query(apptSql, apptParams);

    const waitingList: any[] = [];
    const activeInRoom = new Map<number, any>();
    const now = new Date();

    for (const row of apptRows) {
      const arrived = row.DateTimeArrived && new Date(row.DateTimeArrived).getFullYear() > 1880 ? new Date(row.DateTimeArrived) : null;
      const seated = row.DateTimeSeated && new Date(row.DateTimeSeated).getFullYear() > 1880 ? new Date(row.DateTimeSeated) : null;
      const dismissed = row.DateTimeDismissed && new Date(row.DateTimeDismissed).getFullYear() > 1880 ? new Date(row.DateTimeDismissed) : null;

      const minsWaiting = arrived ? Math.max(0, Math.floor((now.getTime() - arrived.getTime()) / 60000)) : 0;
      const item = {
        aptNum: row.AptNum,
        patNum: row.PatNum,
        patientName: row.PatientName,
        queueLabel: row.QueueLabel || `#${row.AptNum}`,
        opNum: row.OpNum || 0,
        opName: row.OpName || 'Poli Gigi',
        provNum: row.ProvNum || 0,
        provName: row.ProvName || 'Dokter Gigi',
        dateTimeArrived: arrived,
        dateTimeSeated: seated,
        minutesWaiting: minsWaiting
      };

      if (arrived && !seated && !dismissed) {
        waitingList.push(item);
      } else if (seated && !dismissed) {
        if (item.opNum > 0 && !activeInRoom.has(item.opNum)) {
          activeInRoom.set(item.opNum, item);
        }
      }
    }

    const rooms = opRows.map((op: any) => {
      const pat = activeInRoom.get(op.OperatoryNum);
      return {
        operatoryNum: op.OperatoryNum,
        opName: op.OpName,
        provName: pat ? pat.provName : (op.ProvName || 'Dokter Gigi'),
        status: pat ? 'Serving' : 'Available',
        currentPatient: pat ? { queueLabel: pat.queueLabel, patientName: pat.patientName } : null
      };
    });

    res.json({
      clinicNum,
      clinicName,
      clinicAddress,
      currentCalling: lastCalled,
      rooms,
      waitingList,
      marqueeText: 'Selamat Datang di Helianz Dental Care • Harap perhatikan nomor antrian pada layar • Jaga kebersihan gigi Anda dengan kontrol berkala setiap 6 bulan • Terima kasih.',
      timestamp: new Date().toISOString()
    });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/call', async (req: Request, res: Response) => {
  try {
    const { aptNum, opNum, provNum } = req.body;
    const [rows]: any = await pool.query(
      `SELECT a.AptNum, a.PatNum, CONCAT(p.FName, ' ', p.LName) AS PatientName,
              a.QueueLabel, a.Op AS OpNum, o.OpName,
              a.ProvNum, CONCAT(prov.FName, ' ', prov.LName) AS ProvName
       FROM appointment a
       JOIN patient p ON a.PatNum = p.PatNum
       LEFT JOIN operatory o ON a.Op = o.OperatoryNum
       LEFT JOIN provider prov ON a.ProvNum = prov.ProvNum
       WHERE a.AptNum = ?`,
      [aptNum]
    );

    if (!rows || rows.length === 0) {
      return res.status(404).json({ error: 'Appointment not found' });
    }

    const appt = rows[0];
    lastCalled = {
      aptNum: appt.AptNum,
      patNum: appt.PatNum,
      patientName: appt.PatientName,
      queueLabel: appt.QueueLabel || `#${appt.AptNum}`,
      opNum: opNum || appt.OpNum || 1,
      opName: appt.OpName || 'Poli Gigi',
      provNum: provNum || appt.ProvNum || 1,
      provName: appt.ProvName || 'Dokter Gigi',
      lastCalledAt: new Date().toISOString()
    };

    res.json(lastCalled);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
