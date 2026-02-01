import { Pool } from 'pg';
import dotenv from 'dotenv';

// .env dosyasını yükle
dotenv.config();

// KÖSTEBEK: Bakalım linki okuyabiliyor mu?
console.log("------------------------------------------");
console.log("ENV DURUMU:", process.env.DATABASE_URL ? "DOLU ✅" : "BOŞ ❌");
console.log("OKUNAN LINK:", process.env.DATABASE_URL); 
console.log("------------------------------------------");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

pool.on('error', (err) => {
  console.error('Beklenmedik veritabanı hatası:', err);
  process.exit(-1);
});

export const query = (text: string, params?: any[]) => pool.query(text, params);