import 'dart:io'; // Dosya işlemleri için
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Kamera için
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // OCR için
import '../services/otopark_servisi.dart';

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

  // --- KAMERA VE OCR DEĞİŞKENLERİ ---
  File? _cekilenResim; // Ekranda göstermek için
  final ImagePicker _picker = ImagePicker();

  // --- KAMERA VE OCR FONKSİYONU ---
  Future<void> _kamerayiAcVePlakaOkut() async {
    try {
      // 1. Kamerayı Aç ve Fotoğraf Çek
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

      if (photo == null) return; // Fotoğraf çekmeden geri döndü

      setState(() {
        _cekilenResim = File(photo.path); // Resmi ekranda gösterelim
      });

      // 2. ML Kit ile Yazıyı Okuma (OCR Başlıyor)
      final inputImage = InputImage.fromFilePath(photo.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      // 3. Okunan metinleri analiz et ve Plakayı Bul
      // Basit filtre: Boşlukları sil, büyük harf yap
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          String satir = line.text.replaceAll(" ", "").toUpperCase();

          // Kural: 5 karakterden uzunsa ve içinde rakam varsa plakadır (Basit mantık)
          if (satir.length > 5 && satir.contains(RegExp(r'[0-9]'))) {
            setState(() {
              _plakaController.text = line.text.toUpperCase(); // Kutuyu doldur!
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Plaka tespit edildi! 🤖"),
                backgroundColor: Colors.green,
              ),
            );

            textRecognizer.close(); // İşi bitir
            return; // İlk bulduğunu al ve çık
          }
        }
      }

      textRecognizer.close();
    } catch (e) {
      debugPrint("Hata oluştu: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kamera hatası veya iptal edildi"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
            
            // 1. KAMERA ALANI (GestureDetector ile sarmaladık ki tıklanabilsin)
            GestureDetector(
              onTap: _kamerayiAcVePlakaOkut, // Tıklayınca fonksiyon çalışsın
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                  // Eğer resim varsa arka plan olarak onu göster
                  image: _cekilenResim != null
                      ? DecorationImage(
                          image: FileImage(_cekilenResim!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _cekilenResim == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("Plakayı Taramak İçin Dokun 📸",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )
                    : null, // Resim varsa ikonları gizle
              ),
            ),
            
            const SizedBox(height: 24),

            // 2. PLAKA GİRİŞ ALANI
            const Text("Plaka",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
              textCapitalization:
                  TextCapitalization.characters, // Harfleri otomatik büyütür
            ),
            const SizedBox(height: 24),

            // 3. ARAÇ TİPİ SEÇİMİ
            const Text("Araç Tipi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                  items: <String>[
                    'Otomobil',
                    'Motosiklet',
                    'Kamyonet',
                    'Minibüs'
                  ].map<DropdownMenuItem<String>>((String value) {
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
              onPressed: () {
                if (_plakaController.text.isEmpty) return;

                // 1. Servisi Çağır ve Kaydet
                OtoparkServisi().aracGiris(
                    _plakaController.text, secilenAracTipi);

                // 2. Bilgi Mesajı
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${_plakaController.text} girişi başarıyla yapıldı!'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );

                // 3. Çıkış
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text("GİRİŞİ ONAYLA"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}