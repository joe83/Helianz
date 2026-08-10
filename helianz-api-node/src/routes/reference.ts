import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/auth';
import * as svc from '../services/referenceDataService';

const router = Router();
router.use(authenticate);

/**
 * @swagger
 * /api/reference:
 *   get:
 *     tags: [Reference]
 *     summary: Get all reference data (providers, operatories, procedure codes, etc.)
 *     parameters:
 *       - in: query
 *         name: clinicNum
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Reference data bundle
 */
router.get('/', async (req: Request, res: Response) => {
  try {
    const clinicNum = req.query.clinicNum ? Number(req.query.clinicNum) : 0;
    const data = await svc.getAllAsync(clinicNum);
    res.json(data);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
