import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/auth';
import pool from '../config/database';
import { RowDataPacket } from 'mysql2';

const router = Router();
router.use(authenticate);

/**
 * @swagger
 * /api/dashboard/kpis:
 *   get:
 *     tags: [Dashboard]
 *     summary: Key Performance Indicators
 *     responses:
 *       200:
 *         description: KPI data
 */
router.get('/kpis', async (_req: Request, res: Response) => {
  try {
    const conn = await pool.getConnection();
    try {
      const [todayAppts] = await conn.query<RowDataPacket[]>(
        `SELECT COUNT(*) AS cnt FROM appointment
         WHERE AptDateTime >= CURDATE() AND AptDateTime < DATE_ADD(CURDATE(), INTERVAL 1 DAY)
           AND AptStatus IN (1, 6)`
      );
      const [waitingRoom] = await conn.query<RowDataPacket[]>(
        `SELECT COUNT(*) AS cnt FROM appointment
         WHERE AptDateTime >= CURDATE() AND AptDateTime < DATE_ADD(CURDATE(), INTERVAL 1 DAY)
           AND AptStatus = 6`
      );
      const [todayProd] = await conn.query<RowDataPacket[]>(
        `SELECT IFNULL(SUM(ProcFee), 0) AS total FROM procedurelog
         WHERE ProcDate >= CURDATE() AND ProcDate < DATE_ADD(CURDATE(), INTERVAL 1 DAY)
           AND ProcStatus = 2`
      );
      const [pendingRx] = await conn.query<RowDataPacket[]>(
        `SELECT COUNT(*) AS cnt FROM rxpat WHERE RxDate >= CURDATE()`
      );
      const [activePatients] = await conn.query<RowDataPacket[]>(
        `SELECT COUNT(*) AS cnt FROM patient WHERE PatStatus = 0`
      );
      const [monthRevenue] = await conn.query<RowDataPacket[]>(
        `SELECT IFNULL(SUM(PayAmt), 0) AS total FROM payment
         WHERE PayDate >= DATE_FORMAT(CURDATE(), '%Y-%m-01')`
      );

      res.json({
        todayAppointments: todayAppts[0].cnt,
        waitingRoom: waitingRoom[0].cnt,
        todayProduction: todayProd[0].total,
        pendingRx: pendingRx[0].cnt,
        activePatients: activePatients[0].cnt,
        monthRevenue: monthRevenue[0].total,
      });
    } finally {
      conn.release();
    }
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @swagger
 * /api/dashboard/revenue/trends:
 *   get:
 *     tags: [Dashboard]
 *     summary: Revenue trends over time
 *     parameters:
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Revenue trend data
 */
router.get('/revenue/trends', async (req: Request, res: Response) => {
  try {
    const conn = await pool.getConnection();
    try {
      const start = (req.query.startDate as string) || new Date(Date.now() - 180 * 86400000).toISOString().substring(0, 7) + '-01';
      const end = (req.query.endDate as string) || new Date().toISOString().substring(0, 10);

      const [rows] = await conn.query<RowDataPacket[]>(
        `SELECT
           DATE_FORMAT(ProcDate, '%Y-%m') AS Period,
           SUM(CASE WHEN ProcStatus = 2 THEN ProcFee ELSE 0 END) AS Production,
           0 AS Collections, 0 AS Adjustments
         FROM procedurelog
         WHERE ProcDate >= ? AND ProcDate < DATE_ADD(?, INTERVAL 1 DAY)
         GROUP BY Period ORDER BY Period`,
        [start, end]
      );

      res.json(rows);
    } finally {
      conn.release();
    }
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
