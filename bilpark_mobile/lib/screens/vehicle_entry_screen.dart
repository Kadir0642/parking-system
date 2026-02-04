import '../services/otopark_servisi.dart';
import '../models/arac.dart'; // (Gerekirse)
import 'package:flutter/material.dart';

class VehicleEntryScreen extends StatefulWidget {
  const VehicleEntryScreen({super.key});

  @override
  State<VehicleEntryScreen> createState() => _VehicleEntryScreenState();
}

class _VehicleEntryScreenState extends State<VehicleEntryScreen> {
  // Seçilen araç tipi için değişken
  String secilenAracTipi = 'Otomobil';
  
  // Plakayı yazdığımız kutuyu kontrol eden mekanizma
  final TextEditingController _plakaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araç Girişi'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. KAMERA İKONU (İleride burası gerçek kamera olacak)
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                  Text("Kamera ile Tara (Yakında)", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. PLAKA GİRİŞ ALANI
            const Text("Plaka", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _plakaController,
              decoration: InputDecoration(
                hintText: '34 ABC 123',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                prefixIcon: const Icon(Icons.confirmation_number),
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
              textCapitalization: TextCapitalization.characters, // Harfleri otomatik büyütür
            ),
            const SizedBox(height: 24),

            // 3. ARAÇ TİPİ SEÇİMİ (Dropdown)
            const Text("Araç Tipi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: secilenAracTipi,
                  isExpanded: true,
                  items: <String>['Otomobil', 'Motosiklet', 'Kamyonet', 'Minibüs']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      secilenAracTipi = newValue!;
                    });
                  },
                ),
              ),
            ),
            
            const Spacer(), // Butonu en alta iter

            // 4. KAYDET BUTONU
            ElevatedButton.icon(
              // KAYDET BUTONU KISMI
              onPressed: () {
                if (_plakaController.text.isEmpty) return; // Plaka boşsa işlem yapma

                // 1. Servisi Çağır ve Kaydet
                OtoparkServisi().aracGiris(
                  _plakaController.text, 
                  secilenAracTipi
                );

                // 2. Bilgi Mesajı Göster
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${_plakaController.text} girişi başarıyla yapıldı!'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );

                // 3. Ekranı Kapat ve Dashboard'a dön (Veri güncellensin diye)
                Navigator.pop(context); 
              },
              icon: const Icon(Icons.save),
              label: const Text("GİRİŞİ ONAYLA"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}