import 'package:flutter/material.dart';
import 'login_screen.dart'; // Çıkış yapınca Login'e dönmek için

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Ayar Durumları (Değişkenler)
  bool _karanlikMod = false;
  bool _otomatikFisYazdir = true;
  double _saatlikUcret = 30.0; // Varsayılan ücret

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. TARİFE BÖLÜMÜ
          const Text("Tarife Ayarları", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.green),
              title: const Text("Saatlik Ücret"),
              subtitle: Text("${_saatlikUcret.toStringAsFixed(0)} TL / Saat"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _ucretDegistirPenceresi(context);
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // 2. CİHAZ AYARLARI
          const Text("Cihaz & Uygulama", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Otomatik Fiş Yazdır"),
                  subtitle: const Text("Çıkış işleminden sonra yazıcıya gönder"),
                  secondary: const Icon(Icons.print, color: Colors.blueGrey),
                  value: _otomatikFisYazdir,
                  onChanged: (bool value) {
                    setState(() {
                      _otomatikFisYazdir = value;
                    });
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text("Karanlık Mod"),
                  secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
                  value: _karanlikMod,
                  onChanged: (bool value) {
                    setState(() {
                      _karanlikMod = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tema ayarı henüz aktif değil 🛠️')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // 3. ÇIKIŞ YAP BUTONU
          ElevatedButton.icon(
            onPressed: () {
              // Tüm sayfa geçmişini sil ve Login ekranına dön
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text("GÜVENLİ ÇIKIŞ"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[100],
              foregroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 50),
              elevation: 0,
            ),
          ),
          
          const SizedBox(height: 20),
          const Center(child: Text("Versiyon 1.0.0", style: TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }

  // Ücreti değiştirmek için açılan küçük pencere (Dialog)
  void _ucretDegistirPenceresi(BuildContext context) {
    TextEditingController fiyatController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeni Ücret Girin"),
          content: TextField(
            controller: fiyatController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Örn: 40", suffixText: "TL"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Girilen yazıyı sayıya çevir, boşsa 0 yap
                  _saatlikUcret = double.tryParse(fiyatController.text) ?? _saatlikUcret;
                });
                Navigator.pop(context);
              },
              child: const Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }
}