# 🅿️ BilPark - Akıllı Otopark Yönetim Sistemi

> **"Park Et & Unut"**: Şehir içi otopark yönetimini dijitalleştiren, gelir kaçağını önleyen ve operasyonu hızlandıran IoT tabanlı çözüm.

## 🎯 Projenin Amacı (The Problem & Solution)

**Problem:**
Mevcut sistemde otopark görevlileri kağıt-kalem ile araç takibi yapmakta, giriş-çıkış saatlerini manuel not etmektedir. Bu durum:
* Yoğun saatlerde araçların kaçmasına (gelir kaybına),
* Süre hesaplamalarında vatandaş ile tartışmalara,
* Veri güvenliği ve raporlama eksikliğine yol açmaktadır.

**Çözüm:**
BilPark, mobil uygulama ve görüntü işleme (OCR) teknolojilerini kullanarak süreci otomatize eder. Görevli sadece aracın fotoğrafını çeker; sistem plakayı, konumu ve saati otomatik işler.

---

## 🛠️ Kullanılan Teknolojiler (Tech Stack)

Bu proje **Monorepo** mimarisi ile geliştirilmektedir.

### Backend (Sunucu & API)
* **Dil:** TypeScript & Node.js
* **Framework:** Express.js
* **Veritabanı:** PostgreSQL (Supabase)
* **Araçlar:** Git, VS Code

### Mobile (Saha Personeli Uygulaması) - *Geliştirme Aşamasında*
* **Framework:** React Native (Expo)
* **Özellikler:** Kamera Entegrasyonu, Konum Servisleri

### AI & Görüntü İşleme
* **Teknoloji:** OCR (Optik Karakter Tanıma) & YOLO Modelleri
* **İşlev:** Otomatik plaka tanıma ve araç tipi sınıflandırma

---

## 🚀 Kurulum ve Çalıştırma

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin.

### Ön Gereksinimler
* Node.js (v18+)
* Git

### 1. Repoyu Klonlayın
```bash
git clone [https://github.com/Kadir0642/bilpark-parking-system.git](https://github.com/Kadir0642/bilpark-parking-system.git)
cd bilpark-parking-system
```

### 2. Backend Kurulumu
```bash
cd backend
npm install
```

### 3.Geliştirme Sunucusunu Başlatma
```bash
npm run dev
```

-Sunucu varsayılan olarak http://localhost:3000 adresinde çalışacaktır.

### 🗺️ Yol Haritası (Roadmap)
```bash
[x] Proje Mimarisi ve Backend Kurulumu

[ ] Veritabanı Tasarımı ve Bağlantısı

[ ] API Endpoint lerinin Yazılması (Giriş/Çıkış İşlemleri)

[ ] Mobil Uygulama Arayüz Tasarımı

[ ] Kamera ve OCR Entegrasyonu

[ ] Yönetici Paneli Raporlamaları
```