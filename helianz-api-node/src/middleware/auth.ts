import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { JwtPayload } from '../models';

const JWT_KEY = process.env.JWT_KEY || 'HelianzDevKey-ChangeInProduction-Min32Chars!';

/**
 * Express middleware — validates JWT Bearer token.
 * Attaches decoded payload to req.user.
 */
export function authenticate(req: Request, res: Response, next: NextFunction): void {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    res.status(401).json({ error: 'Missing or invalid Authorization header' });
    return;
  }

  const token = authHeader.substring(7);
  try {
    const decoded = jwt.verify(token, JWT_KEY) as JwtPayload;
    (req as any).user = decoded;
    next();
  } catch {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
}

/**
 * Extract allowed clinic numbers from the JWT claims.
 */
export function getAllowedClinics(req: Request): number[] {
  const user = (req as any).user as JwtPayload | undefined;
  if (!user || !user.ClinicNum) return [];
  return user.ClinicNum.map(Number);
}

/**
 * Extract UserNum from the JWT (NameIdentifier claim).
 */
export function getUserId(req: Request): number {
  const user = (req as any).user as JwtPayload | undefined;
  return user ? parseInt(user.sub, 10) : 0;
}
