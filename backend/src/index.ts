/* Artık "npm run dev" ile çalışır.
* "dev":"nodemon src/index.ts" sayesinde (package.json/scripts)
* nodemon devreye girecek ve her kayıt alışta 
* sunucuyu otomatik yeniden başlatacak.
*/
import express, {Request, Response } from 'express';

import dotenv from 'dotenv';

//1.ayarları yükle (.env dosyasını okur)
dotenv.config();

//2.Uygulamayı (Server) oluştur.
const app =express(); // bana boş bir sunucu binası inşa et

//Eğer .env dosyasında PORT yoksa 3000'i kullan
const PORT=process.env.PORT || 3000;

// 3.bir "Rota" (Route) Tanımla
//Tarayıcıdan ana sayfaya "localhost:3000/" gelindiğinde ne olsun ?

//Birisi kapıdan ( ana adres / )girerse,ona "... mesajı göster"
app.get('/',(req: Request, res:Response)=> {
    res.send('Bilpark Backend Servisi Çalişiyor! ');
});

//4.Sunucuyu Başlat ve Dinlemeye Başla
app.listen(PORT, ()=>{
    console.log(`Sunucu şu adreste çalişiyor: http://localhost:${PORT}`);
})
//3000 numaralı Port için dinlemeye al

