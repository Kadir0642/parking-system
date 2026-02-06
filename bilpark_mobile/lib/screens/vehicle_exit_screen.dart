import 'package:flutter/material.dart';
import '../models/arac.dart';
import '../services/otopark_servisi.dart';

class VehicleExitScreen extends StatefulWidget {
  const VehicleExitScreen({super.key});

  @override
  State<VehicleExitScreen> createState() => _VehicleExitScreenState();
}

class _VehicleExitScreenState extends State<VehicleExitScreen> {
  final TextEditingController _plakaController = TextEditingController();
  
  // Bulunan aracı tutmak için değişken (Başta boş)
  Arac? _bulunanArac;

  // Anlık hesaplanan ücreti ekranda göstermek için
  double _anlikUcret = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araç Çıkışı'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. ARAMA KUTUSU
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text("Çıkış Yapacak Plaka", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _plakaController,
                      decoration: InputDecoration(
                        hintText: '34 ABC 123',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.red),
                          onPressed: _aracSorgula, // Butona basınca bu fonksiyon çalışacak
                        ),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // 2. SONUÇ FİŞİ (Eğer araç bulunduysa göster)
            if (_bulunanArac != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.receipt_long, size: 60, color: Colors.red),
                    const SizedBox(height: 10),
                    Text(
                      _bulunanArac!.plaka, 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                    ),
                    const Divider(thickness: 2),
                    const SizedBox(height: 10),
                    
                    _bilgiSatiri("Giriş Saati", "${_bulunanArac!.girisSaati.hour}:${_bulunanArac!.girisSaati.minute.toString().padLeft(2, '0')}"),
                    _bilgiSatiri("Araç Tipi", _bulunanArac!.tip),
                    
                    const Divider(thickness: 2),
                    const SizedBox(height: 10),
                    const Text("TOPLAM TUTAR", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    Text(
                      "$_anlikUcret ₺", 
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 20),
                    
                    // ÖDEME AL BUTONU
                    ElevatedButton(
                      onPressed: _cikisYapVeTahsilEt,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("NAKİT TAHSİL ET & ÇIKIŞ YAP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- YARDIMCI FONKSİYONLAR ---

  // 1. Servise gidip plakayı soran fonksiyon
  void _aracSorgula() {
    // Klavyeyi kapat
    FocusScope.of(context).unfocus(); 

    if (_plakaController.text.isEmpty) return;

    setState(() {
      // Servisten aracı bul
      _bulunanArac = OtoparkServisi().aracBul(_plakaController.text);
      
      if (_bulunanArac == null) {
        // Araç bulunamadıysa uyarı ver
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bu plakaya ait içeride araç yok! ❌')),
        );
      } else {
        // Araç bulunduysa, tahmini ücreti hesapla (Göstermelik)
        Duration sure = DateTime.now().difference(_bulunanArac!.girisSaati);
        double saat = sure.inMinutes / 60.0;
        if (saat < 0.25) { // 15 dk altı ücretsiz
           _anlikUcret = 0;
        } else {
           _anlikUcret = (saat.ceil()) * 30.0; // Saatlik 30 TL (Ayarlardan da çekilebilir ileride)
        }
      }
    });
  }

  // 2. Çıkışı onaylayan fonksiyon
  void _cikisYapVeTahsilEt() {
    if (_bulunanArac != null) {
      setState(() {
        // Servisteki çıkış işlemini çalıştır (Ücreti kesinleştirir ve aracı dışarı atar)
        OtoparkServisi().aracCikis(_bulunanArac!, 30.0);
        
        // Başarı mesajı
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_bulunanArac!.plaka} çıkışı yapıldı. Tahsilat: $_anlikUcret ₺ ✅'), 
            backgroundColor: Colors.green
          ),
        );

        // Ekranı temizle
        _bulunanArac = null;
        _plakaController.clear();
      });
    }
  }

  Widget _bilgiSatiri(String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(baslik, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(deger, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}