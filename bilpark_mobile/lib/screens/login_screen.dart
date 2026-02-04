import 'dashboard_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Şifrenin görünüp görünmediğini kontrol eden değişken
  bool _sifreGozuksunMu = false;

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
                // 1. LOGO VE BAŞLIK BÖLÜMÜ
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

                // 2. KULLANICI ADI KUTUSU
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. ŞİFRE KUTUSU
                TextField(
                  obscureText: !_sifreGozuksunMu, // Şifreyi gizle/göster
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

                // 4. GİRİŞ BUTONU
              // 4. GİRİŞ BUTONU (Burası değişti)
                ElevatedButton(
                  onPressed: () {
                    // Butona basınca Dashboard sayfasına git
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
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
              ], // <--- İŞTE BU KÖŞELİ PARANTEZ EKSİKTİ
            ),
          ),
        ),
      ),
    );
  }
}