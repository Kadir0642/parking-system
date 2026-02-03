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
import cors from 'cors';
import { query } from './db';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// 1. DİKKAT: Gelen JSON verilerini okumak için bu ayar ŞARTTIR!
app.use(cors()); // (Tüm dünyadan gelen isteklere kapıyı açar)
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

// 🚀 ÖZELLİK 2: ARAÇ ÇIKIŞI (CHECK-OUT)
app.post('/check-out', async (req: Request, res: Response) => {
    try {
        const { plate_number } = req.body;

        if (!plate_number) {
            return res.status(400).json({ error: 'Plaka numarası gereklidir!' });
        }

        console.log(`Çıkış İsteği: ${plate_number}`);

        // 1. Adım: Bu plakaya ait aracı bul
        const vehicleResult = await query('SELECT id FROM vehicles WHERE plate_number = $1', [plate_number]);
        
        if (vehicleResult.rows.length === 0) {
            return res.status(404).json({ error: 'Araç bulunamadı!' });
        }

        const vehicleId = vehicleResult.rows[0].id;

        // 2. Adım: Aracın içeride olduğu (aktif) kaydı bul
        const parkResult = await query(
            'SELECT * FROM parks WHERE vehicle_id = $1 AND is_active = true', 
            [vehicleId]
        );

        if (parkResult.rows.length === 0) {
            return res.status(400).json({ error: 'Bu araç zaten dışarıda veya hiç girmemiş!' });
        }

        const parkRecord = parkResult.rows[0];

        // 3. Adım: Süreyi ve Ücreti Hesapla 🧮
        const entryTime = new Date(parkRecord.entry_time); // Giriş saati
        const exitTime = new Date(); // Şu an (Çıkış saati)
        
        // Milisaniye cinsinden farkı alıp saate çeviriyoruz
        const diffMs = exitTime.getTime() - entryTime.getTime();
        const diffHours = diffMs / (1000 * 60 * 60);

        // Saatlik ücret: 50 TL (Örnek)
        // Math.ceil: Yukarı yuvarlar (1.2 saat -> 2 saat sayılır)
        const hourlyRate = 50;
        const totalHours = Math.ceil(diffHours); 
        const totalPrice = totalHours * hourlyRate;

        // 4. Adım: Kaydı güncelle (Çıkış saatini ve ücreti yaz, aktifliği bitir)
        await query(
            'UPDATE parks SET exit_time = $1, total_price = $2, is_active = false WHERE id = $3',
            [exitTime, totalPrice, parkRecord.id]
        );

        // Sonuç döndür
        res.json({
            message: 'Çıkış Başarılı! 👋',
            plate: plate_number,
            stay_duration: `${diffHours.toFixed(2)} saat`,
            total_price: `${totalPrice} TL`
        });

    } catch (error) {
        console.error("Çıkış Hatası:", error);
        res.status(500).json({ error: 'Sunucu hatası oluştu' });
    }
});

// 🚀 ÖZELLİK 3: İÇERİDEKİ ARAÇLARI LİSTELE
// Bu adres çağrılınca sadece "is_active = true" olanları getirir.
app.get('/active-vehicles', async (req: Request, res: Response) => {
    try {
        // SQL JOIN: Hem park kaydını al hem de plaka bilgisini 'vehicles' tablosundan çek.
        const result = await query(`
            SELECT v.plate_number, p.entry_time 
            FROM parks p
            JOIN vehicles v ON p.vehicle_id = v.id
            WHERE p.is_active = true
            ORDER BY p.entry_time DESC
        `);
        
        res.json(result.rows);
    } catch (error) {
        console.error("Listeleme Hatası:", error);
        res.status(500).json({ error: 'Veriler çekilemedi' });
    }
});

// 🧨 TEHLİKELİ BÖLGE: SİSTEMİ SIFIRLA
// Bu komut tüm kayıtları siler ve araçları temizler!
app.delete('/reset', async (req: Request, res: Response) => {
    try {
        // TRUNCATE: Tabloyu boşaltır
        // CASCADE: İlişkili verileri de siler (Park kayıtları silinince araçlar da silinir)
        // RESTART IDENTITY: ID sayacını 1'e geri alır
        await query('TRUNCATE vehicles, parks RESTART IDENTITY CASCADE');
        
        console.log("⚠️ SİSTEM SIFIRLANDI!");
        res.json({ message: 'Sistem fabrika ayarlarına döndü! 🧹' });
    } catch (error) {
        console.error("Sıfırlama Hatası:", error);
        res.status(500).json({ error: 'Sıfırlama yapılamadı' });
    }
});

app.listen(PORT, () => {
    console.log(`Sunucu http://localhost:${PORT} adresinde hazır! 🚀`);
});