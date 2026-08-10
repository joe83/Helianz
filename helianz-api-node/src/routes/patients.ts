import { Router, Request, Response } from 'express';
import { authenticate, getAllowedClinics } from '../middleware/auth';
import * as svc from '../services/patientService';

const router = Router();
router.use(authenticate);

/**
 * @swagger
 * /api/patients:
 *   get:
 *     tags: [Patients]
 *     summary: Search patients
 *     parameters:
 *       - in: query
 *         name: query
 *         schema:
 *           type: string
 *       - in: query
 *         name: clinicNum
 *         schema:
 *           type: integer
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *       - in: query
 *         name: pageSize
 *         schema:
 *           type: integer
 *           default: 20
 *     responses:
 *       200:
 *         description: Paginated patient list
 */
router.get('/', async (req: Request, res: Response) => {
  try {
    const result = await svc.searchAsync({
      query: req.query.query as string | undefined,
      clinicNum: req.query.clinicNum ? Number(req.query.clinicNum) : undefined,
      page: parseInt(req.query.page as string) || 1,
      pageSize: parseInt(req.query.pageSize as string) || 20,
    }, getAllowedClinics(req));
    res.json(result);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @swagger
 * /api/patients/{id}:
 *   get:
 *     tags: [Patients]
 *     summary: Get patient by ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Patient
 *       404:
 *         description: Not found
 */
router.get('/:id', async (req: Request, res: Response) => {
  try {
    const patient = await svc.getByIdAsync(Number(req.params.id), getAllowedClinics(req));
    if (!patient) return res.status(404).json({ error: 'Patient not found' });
    res.json(patient);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @swagger
 * /api/patients:
 *   post:
 *     tags: [Patients]
 *     summary: Create patient
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *     responses:
 *       201:
 *         description: Created patient
 */
router.post('/', async (req: Request, res: Response) => {
  try {
    const patNum = await svc.createAsync(req.body);
    const patient = await svc.getByIdAsync(patNum, getAllowedClinics(req));
    res.status(201).json(patient);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @swagger
 * /api/patients/{id}:
 *   put:
 *     tags: [Patients]
 *     summary: Update patient
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *     responses:
 *       200:
 *         description: Updated
 *       404:
 *         description: Not found or access denied
 */
router.put('/:id', async (req: Request, res: Response) => {
  try {
    const updated = await svc.updateAsync(Number(req.params.id), req.body, getAllowedClinics(req));
    if (!updated) return res.status(404).json({ error: 'Patient not found or access denied' });
    res.json({ message: 'Patient updated' });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
