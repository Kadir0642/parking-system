# 🅿️ BilPark - Akıllı Şehir Otopark Yönetim Sistemi

![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Status](https://img.shields.io/badge/status-Active%20Development-green.svg) ![Tech](https://img.shields.io/badge/tech-Flutter%20%7C%20Node.js%20%7C%20Supabase-blueviolet)

> **"Park Et & Unut"**: Şehir içi otopark yönetimini dijitalleştiren, gelir kaçağını önleyen, IoT ve Yapay Zeka destekli yeni nesil belediye çözümüdür.

---

## 🎯 Proje Vizyonu (Vision)

**Problem:**
Geleneksel sistemde otopark görevlileri ("Değnekçiler") kağıt-kalem veya basit fiş cihazlarıyla çalışmaktadır. Bu durum; denetim eksikliğine, gelir kaçaklarına (kayıt dışı park), hatalı ücret hesaplamalarına ve merkezi bir yönetim eksikliğine neden olmaktadır.

**Çözüm:**
**BilPark**, sahadan veri toplayan bir **Mobil Uygulama** ve bu verileri işleyen merkezi bir **Komuta Paneli (Dashboard)** sunar.
* **Saha Personeli:** Aracın fotoğrafını çeker, OCR ile plaka ve GPS konumu otomatik sisteme işlenir.
* **Yönetim Merkezi:** Hangi caddede kaç araç var, anlık ciro ne kadar, personel performansı nedir canlı izler.

---


## 🛠️ Teknoloji Yığını (Tech Stack)

Proje, ölçeklenebilir ve modern bir mimari üzerine kurulmuştur.

| Alan | Teknoloji | Açıklama |
| :--- | :--- | :--- |
| **Mobile App** | 💙 **Flutter (Dart)** | iOS & Android için Native performanslı saha uygulaması. |
| **Backend** | 💚 **Node.js & TypeScript** | Güvenli, hızlı ve tip korumalı REST API mimarisi. |
| **Database** | ⚡ **PostgreSQL (Supabase)** | İlişkisel veritabanı, gerçek zamanlı veri akışı. |
| **Admin Panel** | 🎨 **HTML5 & Bootstrap 5** | Yönetim ve canlı izleme paneli (Responsive). |
| **AI & OCR** | 👁️ **Google ML Kit** | Cihaz üzerinde (On-device) plaka ve metin okuma. |


---
## 📂 Proje Yapısı

```bash
bilpark-parking-system/
├── backend/            # Node.js & TypeScript API Sunucusu
│   ├── src/
│   │   ├── index.ts    # API Endpoint'leri
│   │   └── db.ts       # Veritabanı Bağlantısı
├── frontend/           # Yönetici Paneli
│   └── dashboard.html  # Canlı İzleme Ekranı
├── mobile_flutter/     # Saha Personel Uygulaması (Geliştirme Aşamasında)
└── README.md           # Proje Dokümantasyonu
```

---

## ⚡ Temel Özellikler (Key Features)
### 🖥️ Yönetici Paneli (Command Center)
* Canlı İzleme: Sahadaki araç giriş-çıkışlarını 3 saniyelik periyotlarla anlık izleme.

* Bölge Filtreleme: "Atatürk Caddesi", "Sahil Yolu" gibi spesifik bölgeleri filtreleyip yoğunluk haritası çıkarma.

* Gelir Yönetimi: Toplam hasılatı ve cadde bazlı ciro dağılımını raporlama.

* Acil Durum: Tek tuşla veritabanı sıfırlama ve sistem yönetimi.

#### 📱 Mobil Uygulama (Saha Personeli)
* OCR ile Hızlı Giriş: Plakayı elle yazmak yok; kamera otomatik okur.

* Konum Etiketleme: Giriş yapılan konumu (GPS) otomatik olarak kaydeder.

* Dinamik Tarife: Giriş-Çıkış saatine göre milisaniye hassasiyetinde ücret hesaplar.

## ⚙️ Kurulum ve Çalıştırma

Projeyi yerel ortamınızda test etmek için aşağıdaki adımları izleyin

### 1. Repoyu Klonlayın
```bash
git clone [https://github.com/Kadir0642/bilpark-parking-system.git](https://github.com/Kadir0642/bilpark-parking-system.git)
cd bilpark-parking-system
```

### 2. Backend Kurulumu
```bash
cd backend
npm install
npm run dev
```
* Sunucu varsayılan olarak http://localhost:3000 adresinde çalışacaktır.
### 3. Yönetici Paneli
```bash
cd backend
npm install
npm run dev
```


### 4. Mobil Uygulama (Flutter)
* (Flutter SDK ve Android Studio kurulu olmalıdır)
```bash
cd mobile_flutter
flutter pub get
flutter run
```


### 🗺️ Yol Haritası (Roadmap)
```bash
[x] Faz 1: Backend Mimarisi (Node.js & Supabase Kurulumu)

[x] Faz 2: Veritabanı Tasarımı (Araçlar, Park Kayıtları, Konum Logları)

[x] Faz 3: API Geliştirme (Giriş, Çıkış, Ciro, Filtreleme Endpointleri)

[x] Faz 4: Yönetici Paneli (Canlı Takip Dashboardu)

[ ] Faz 5: Mobil Uygulama Geliştirme (Flutter UI Tasarımı) 🚧 Şu an buradayız

[ ] Faz 6: Yapay Zeka Entegrasyonu (Kamera ile Plaka Okuma)

[ ] Faz 7: Saha Testleri & Demo
```
