import { Router, Request, Response } from 'express';
import { authenticate, getAllowedClinics } from '../middleware/auth';
import * as svc from '../services/appointmentService';

const router = Router();
router.use(authenticate);

router.get('/', async (req: Request, res: Response) => {
  try {
    const result = await svc.searchAsync({
      dateFrom: req.query.dateFrom as string | undefined,
      dateTo: req.query.dateTo as string | undefined,
      provNum: req.query.provNum ? Number(req.query.provNum) : undefined,
      clinicNum: req.query.clinicNum ? Number(req.query.clinicNum) : undefined,
      patNum: req.query.patNum ? Number(req.query.patNum) : undefined,
      aptStatus: req.query.aptStatus ? Number(req.query.aptStatus) : undefined,
      page: parseInt(req.query.page as string) || 1,
      pageSize: parseInt(req.query.pageSize as string) || 50,
    }, getAllowedClinics(req));
    res.json(result);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/today', async (req: Request, res: Response) => {
  try {
    const result = await svc.getTodayAsync(
      req.query.clinicNum ? Number(req.query.clinicNum) : null,
      req.query.provNum ? Number(req.query.provNum) : null,
      getAllowedClinics(req)
    );
    res.json(result);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/:id', async (req: Request, res: Response) => {
  try {
    const apt = await svc.getByIdAsync(Number(req.params.id), getAllowedClinics(req));
    if (!apt) return res.status(404).json({ error: 'Appointment not found' });
    res.json(apt);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/', async (req: Request, res: Response) => {
  try {
    const aptNum = await svc.createAsync(req.body);
    const apt = await svc.getByIdAsync(aptNum, getAllowedClinics(req));
    res.status(201).json(apt);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.put('/:id', async (req: Request, res: Response) => {
  try {
    const updated = await svc.updateAsync(Number(req.params.id), req.body, getAllowedClinics(req));
    if (!updated) return res.status(404).json({ error: 'Appointment not found' });
    res.json({ message: 'Appointment updated' });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/:id/complete', async (req: Request, res: Response) => {
  try {
    const updated = await svc.setCompleteAsync(Number(req.params.id), getAllowedClinics(req));
    if (!updated) return res.status(404).json({ error: 'Appointment not found' });
    res.json({ message: 'Appointment marked complete' });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
