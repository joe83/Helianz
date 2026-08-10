import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

export interface DbConfig {
  server: string;
  port: number;
  database: string;
  user: string;
  password: string;
  poolMin: number;
  poolMax: number;
}

function loadConfig(): DbConfig {
  return {
    server: process.env.DB_SERVER || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    database: process.env.DB_NAME || 'helianz',
    user: process.env.DB_USER || 'oduser',
    password: process.env.DB_PASSWORD || '',
    poolMin: parseInt(process.env.DB_POOL_MIN || '2', 10),
    poolMax: parseInt(process.env.DB_POOL_MAX || '50', 10),
  };
}

const config = loadConfig();

const pool = mysql.createPool({
  host: config.server,
  port: config.port,
  database: config.database,
  user: config.user,
  password: config.password,
  waitForConnections: true,
  connectionLimit: config.poolMax,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 10000,
});

export default pool;
