import 'package:flutter/material.dart';

class VehicleExitScreen extends StatefulWidget {
  const VehicleExitScreen({super.key});

  @override
  State<VehicleExitScreen> createState() => _VehicleExitScreenState();
}

class _VehicleExitScreenState extends State<VehicleExitScreen> {
  final TextEditingController _plakaController = TextEditingController();
  
  // Ekranda sonuç kartını gösterip gizlemek için değişken
  bool _aracBulundu = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araç Çıkışı'),
        backgroundColor: Colors.red, // Çıkış olduğu için Kırmızı
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
                          onPressed: () {
                            // Arama butonuna basınca sahte bir sonuç gösterelim
                            if (_plakaController.text.isNotEmpty) {
                              setState(() {
                                _aracBulundu = true;
                              });
                            }
                          },
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

            // 2. SONUÇ FİŞİ (Sadece araç bulununca gözükecek)
            if (_aracBulundu)
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
                    Text(_plakaController.text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const Divider(thickness: 2),
                    const SizedBox(height: 10),
                    
                    _bilgiSatiri("Giriş Saati", "10:30"),
                    _bilgiSatiri("Çıkış Saati", "14:45"),
                    _bilgiSatiri("Süre", "4 Saat 15 Dk"),
                    _bilgiSatiri("Araç Tipi", "Otomobil"),
                    
                    const Divider(thickness: 2),
                    const SizedBox(height: 10),
                    const Text("TOPLAM TUTAR", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    const Text(
                      "120.00 ₺", 
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 20),
                    
                    // ÖDEME AL BUTONU
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ödeme alındı, çıkış onaylandı! ✅'), backgroundColor: Colors.green),
                        );
                        setState(() {
                          _aracBulundu = false; // Ekranı temizle
                          _plakaController.clear();
                        });
                      },
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

  // Fişteki satırları düzenleyen yardımcı fonksiyon
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