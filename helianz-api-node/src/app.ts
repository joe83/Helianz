import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';
import pino from 'pino';

dotenv.config();

const logger = pino({
  name: 'helianz-api',
  transport: process.env.NODE_ENV === 'development'
    ? { target: 'pino-pretty', options: { colorize: true } }
    : undefined,
});

// ── Routes ────────────────────────────────────────────
import authRoutes from './routes/auth';
import patientRoutes from './routes/patients';
import appointmentRoutes from './routes/appointments';
import procedureRoutes from './routes/procedures';
import paymentRoutes from './routes/payments';
import prescriptionRoutes from './routes/prescriptions';
import noteRoutes from './routes/notes';
import dashboardRoutes from './routes/dashboard';
import reportRoutes from './routes/reports';
import referenceRoutes from './routes/reference';

const app = express();
const PORT = parseInt(process.env.PORT || '5000', 10);

// ── Middleware ────────────────────────────────────────
app.use(cors());
app.use(express.json());

// Request logging
app.use((req, _res, next) => {
  logger.info({ method: req.method, url: req.url }, 'request');
  next();
});

// ── Swagger ───────────────────────────────────────────
const swaggerSpec = swaggerJsdoc({
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Helianz API',
      version: '1.0.0',
      description: 'Helianz Dental Practice Management API — Node.js/TypeScript',
    },
    servers: [{ url: `http://localhost:${PORT}` }],
    components: {
      securitySchemes: {
        Bearer: {
          type: 'apiKey',
          name: 'Authorization',
          in: 'header',
          description: 'JWT token: Bearer {token}',
        },
      },
    },
    security: [{ Bearer: [] }],
  },
  apis: ['./src/routes/*.ts'],
});

app.use('/swagger', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// ── Routes ────────────────────────────────────────────
app.use('/api/auth', authRoutes);
app.use('/api/patients', patientRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/procedures', procedureRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/prescriptions', prescriptionRoutes);
app.use('/api/notes', noteRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use('/api/reports', reportRoutes);
app.use('/api/reference', referenceRoutes);

// Health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ── Error handler ─────────────────────────────────────
app.use((err: any, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  logger.error({ err }, 'Unhandled error');
  res.status(500).json({ error: err.message || 'Internal server error' });
});

// ── Start ─────────────────────────────────────────────
app.listen(PORT, '0.0.0.0', () => {
  logger.info(`Helianz API (Node.js) running on http://0.0.0.0:${PORT}`);
  logger.info(`Swagger UI: http://localhost:${PORT}/swagger`);
});

// Prevent silent crashes
process.on('uncaughtException', (err) => {
  logger.fatal({ err }, 'Uncaught exception — process will exit');
  setTimeout(() => process.exit(1), 1000);
});
process.on('unhandledRejection', (reason) => {
  logger.fatal({ err: reason }, 'Unhandled rejection');
});

export default app;
