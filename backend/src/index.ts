/* Artık "npm run dev" ile çalışır.
* "dev":"nodemon src/index.ts" sayesinde (package.json/scripts)
* nodemon devreye girecek ve her kayıt alışta 
* sunucuyu otomatik yeniden başlatacak.
*/

/*Klavyeden CTRL + C tuşlarına bas (Sunucuyu durdurur).

Tekrar npm run dev yazıp Enter'a bas.
*/

import express, { Request, Response } from 'express';
import dotenv from 'dotenv';
import { query } from './db';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// 1. DİKKAT: Gelen JSON verilerini okumak için bu ayar ŞARTTIR!
app.use(express.json());

// Basit test rotası
app.get('/', async (req: Request, res: Response) => {
    const result = await query('SELECT NOW()');
    res.send(`BilPark Sunucusu Aktif! Saat: ${result.rows[0].now}`);
});

// 🚀 ÖZELLİK 1: ARAÇ GİRİŞİ (CHECK-IN)
// Bu adrese POST isteği atılınca çalışır
app.post('/check-in', async (req: Request, res: Response) => {
    try {
        const { plate_number } = req.body; // Gelen veriden plakayı al

        if (!plate_number) {
            return res.status(400).json({ error: 'Plaka numarası gereklidir!' });
        }

        console.log(`Giriş İsteği: ${plate_number}`);

        // 1. Adım: Araç daha önce kayıtlı mı?
        let vehicleResult = await query('SELECT * FROM vehicles WHERE plate_number = $1', [plate_number]);
        let vehicleId;

        if (vehicleResult.rows.length === 0) {
            // Kayıtlı değilse yeni oluştur
            console.log('Yeni araç oluşturuluyor...');
            const newVehicle = await query(
                'INSERT INTO vehicles (plate_number) VALUES ($1) RETURNING id',
                [plate_number]
            );
            vehicleId = newVehicle.rows[0].id;
        } else {
            // Zaten varsa ID'sini al
            console.log('Araç zaten kayıtlı.');
            vehicleId = vehicleResult.rows[0].id;
        }

        // 2. Adım: Park kaydı oluştur (Giriş yap)
        // is_active = true demek "araç şu an içeride" demektir.
        const parkResult = await query(
            'INSERT INTO parks (vehicle_id, is_active) VALUES ($1, true) RETURNING *',
            [vehicleId]
        );

        // Başarılı cevabı döndür
        res.json({
            message: 'Giriş Başarılı! 🚧 Bariyer Açılıyor...',
            park_record: parkResult.rows[0]
        });

    } catch (error) {
        console.error("Giriş Hatası:", error);
        res.status(500).json({ error: 'Sunucu hatası oluştu' });
    }
});

app.listen(PORT, () => {
    console.log(`Sunucu http://localhost:${PORT} adresinde hazır! 🚀`);
});