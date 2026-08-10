import { Router, Request, Response } from 'express';
import { authenticate, getAllowedClinics } from '../middleware/auth';
import * as svc from '../services/prescriptionService';

const router = Router();
router.use(authenticate);

router.get('/', async (req: Request, res: Response) => {
  try {
    const result = await svc.searchAsync({
      patNum: req.query.patNum ? Number(req.query.patNum) : undefined,
      clinicNum: req.query.clinicNum ? Number(req.query.clinicNum) : undefined,
      dateFrom: req.query.dateFrom as string | undefined,
      dateTo: req.query.dateTo as string | undefined,
      page: parseInt(req.query.page as string) || 1,
      pageSize: parseInt(req.query.pageSize as string) || 20,
    }, getAllowedClinics(req));
    res.json(result);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/:id', async (req: Request, res: Response) => {
  try {
    const rx = await svc.getByIdAsync(Number(req.params.id), getAllowedClinics(req));
    if (!rx) return res.status(404).json({ error: 'Prescription not found' });
    res.json(rx);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/', async (req: Request, res: Response) => {
  try {
    const rxNum = await svc.createAsync(req.body);
    const rx = await svc.getByIdAsync(rxNum, getAllowedClinics(req));
    res.status(201).json(rx);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
