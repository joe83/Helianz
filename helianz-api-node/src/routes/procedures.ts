import { Router, Request, Response } from 'express';
import { authenticate, getAllowedClinics } from '../middleware/auth';
import * as svc from '../services/procedureService';

const router = Router();
router.use(authenticate);

router.get('/', async (req: Request, res: Response) => {
  try {
    const result = await svc.searchAsync({
      patNum: req.query.patNum ? Number(req.query.patNum) : undefined,
      clinicNum: req.query.clinicNum ? Number(req.query.clinicNum) : undefined,
      provNum: req.query.provNum ? Number(req.query.provNum) : undefined,
      dateFrom: req.query.dateFrom as string | undefined,
      dateTo: req.query.dateTo as string | undefined,
      procStatus: req.query.procStatus ? Number(req.query.procStatus) : undefined,
      page: parseInt(req.query.page as string) || 1,
      pageSize: parseInt(req.query.pageSize as string) || 50,
    }, getAllowedClinics(req));
    res.json(result);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/chart/:patNum', async (req: Request, res: Response) => {
  try {
    const chart = await svc.getToothChartAsync(Number(req.params.patNum), getAllowedClinics(req));
    if (!chart.patNum) return res.status(404).json({ error: 'Patient not found' });
    res.json(chart);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/', async (req: Request, res: Response) => {
  try {
    const procNum = await svc.createAsync(req.body);
    res.status(201).json({ ProcNum: procNum });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/:id/complete', async (req: Request, res: Response) => {
  try {
    const ok = await svc.setCompleteAsync(Number(req.params.id), getAllowedClinics(req));
    if (!ok) return res.status(404).json({ error: 'Procedure not found' });
    res.json({ message: 'Procedure marked complete' });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
