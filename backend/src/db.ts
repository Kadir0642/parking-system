import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

// Artık loglama yok, sadece işini yapan sessiz bir kod var.
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
});

pool.on('error', (err) => {
    console.error('Beklenmedik veritabani hatasi:', err);
    process.exit(-1);
});

export const query = (text: string, params?: any[]) => pool.query(text, params);