import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Şifrenin görünüp görünmediğini kontrol eden değişken
  bool _sifreGozuksunMu = false;

  // 1. KUTULARI KONTROL ETMEK İÇİN "KUMANDALAR" (Controllers)
  final TextEditingController _kullaniciAdiController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LOGO VE BAŞLIK
                const Icon(
                  Icons.local_parking_rounded,
                  size: 100,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 20),
                const Text(
                  'BilPark',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const Text(
                  'Personel Giriş Sistemi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // 2. KULLANICI ADI KUTUSU (Controller bağlandı)
                TextField(
                  controller: _kullaniciAdiController, // <-- BURAYI EKLEDİK
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. ŞİFRE KUTUSU (Controller bağlandı)
                TextField(
                  controller: _sifreController, // <-- BURAYI EKLEDİK
                  obscureText: !_sifreGozuksunMu,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _sifreGozuksunMu ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _sifreGozuksunMu = !_sifreGozuksunMu;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 4. GİRİŞ BUTONU (Artık güvenlik kontrolü yapıyor)
                ElevatedButton(
                  onPressed: () {
                    // Kutulardaki yazıları al, boşlukları (trim) temizle
                    String kAdi = _kullaniciAdiController.text.trim();
                    String sifre = _sifreController.text.trim();

                    // --- GÜVENLİK KONTROLÜ BAŞLIYOR ---
                    
                    if (kAdi.isEmpty || sifre.isEmpty) {
                      // HATA: Alanlar boşsa
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lütfen kullanıcı adı ve şifreyi girin! ⚠️"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    } 
                    else if (kAdi == "admin" && sifre == "123456") {
                      // BAŞARILI: Giriş izni ver
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Giriş Başarılı! Hoşgeldiniz 👋"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardScreen()),
                      );
                    } 
                    else {
                      // HATA: Yanlış bilgi
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Hatalı kullanıcı adı veya şifre! ⛔"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'GİRİŞ YAP',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                
                const SizedBox(height: 20),
                const Text(
                  "Demo Giriş: admin / 123456",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}