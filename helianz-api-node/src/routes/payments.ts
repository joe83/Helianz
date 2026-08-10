import { Router, Request, Response } from 'express';
import { authenticate, getAllowedClinics, getUserId } from '../middleware/auth';
import * as svc from '../services/paymentService';

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
      pageSize: parseInt(req.query.pageSize as string) || 50,
    }, getAllowedClinics(req));
    res.json(result);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/:id', async (req: Request, res: Response) => {
  try {
    const payment = await svc.getByIdAsync(Number(req.params.id), getAllowedClinics(req));
    if (!payment) return res.status(404).json({ error: 'Payment not found' });
    res.json(payment);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/', async (req: Request, res: Response) => {
  try {
    const payNum = await svc.createAsync(req.body, getUserId(req));
    const payment = await svc.getByIdAsync(payNum, getAllowedClinics(req));
    res.status(201).json(payment);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
