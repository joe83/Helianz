import { Router, Request, Response } from 'express';
import { authenticate, getAllowedClinics, getUserId } from '../middleware/auth';
import * as svc from '../services/noteService';

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
    const note = await svc.getByIdAsync(Number(req.params.id), getAllowedClinics(req));
    if (!note) return res.status(404).json({ error: 'Note not found' });
    res.json(note);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/', async (req: Request, res: Response) => {
  try {
    const id = await svc.createAsync(req.body, getUserId(req));
    const note = await svc.getByIdAsync(id, getAllowedClinics(req));
    res.status(201).json(note);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
