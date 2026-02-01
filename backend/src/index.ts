/* Artık "npm run dev" ile çalışır.
* "dev":"nodemon src/index.ts" sayesinde (package.json/scripts)
* nodemon devreye girecek ve her kayıt alışta 
* sunucuyu otomatik yeniden başlatacak.
*/

/*Klavyeden CTRL + C tuşlarına bas (Sunucuyu durdurur).

Tekrar npm run dev yazıp Enter'a bas.
*/

import express, {Request, Response } from 'express';
import dotenv from 'dotenv';
import {query} from './db'; // oluşturduğumuz db dosyasını çağırdık.

//1.ayarları yükle (.env dosyasını okur)
dotenv.config();

//2.Uygulamayı (Server) oluştur.
const app =express(); // bana boş bir sunucu binası inşa et

//Eğer .env dosyasında PORT yoksa 3000'i kullan
const PORT=process.env.PORT || 3000;

// 3.bir "Rota" (Route) Tanımla
//Tarayıcıdan ana sayfaya "localhost:3000/" gelindiğinde ne olsun ?

//Ana Sayfa Rotası
app.get('/',async(req:Request,res:Response)=>
{
    try{
        //Veri tabanına "Saat kaç ?" diyelim.
        const result= await query(' SELECT NOW() ');

        //Sonucu ekrana yazalım
        res.send(`
            <h1>Bilpark Backend çalişiyor</h1>
            <p>Veritabani Bağlantisi: <strong>Başarili</strong></p>
            <p>Sunucu Saati: ${result.rows[0].now}</p>
            `);
    }catch(error)
    {
        console.error("Veritabani hatasi",error);
        res.status(500).send('Veritabanina bağlanilamadi !');
    }
})

//4.Sunucuyu Başlat ve Dinlemeye Başla
app.listen(PORT, ()=>{
    console.log(`Sunucu şu adreste çalişiyor: http://localhost:${PORT}`);
})
//3000 numaralı Port için dinlemeye al


// ilerlemeden şuana kadar ne yaptık ettik kodların ne anlam
// ifade ettiğini ve projenin genel fotoları , tablo düzeni vs
// onları ekle sonra veritabanı mimarisi geçelim.