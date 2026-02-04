import 'settings_screen.dart';
import 'history_screen.dart';
import 'vehicle_exit_screen.dart';
import 'vehicle_entry_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Hafif gri arka plan
      appBar: AppBar(
        title: const Text('BilPark Panel'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // Çıkış Butonu
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Çıkış yapıp login ekranına dönme kodu buraya gelecek
              Navigator.pop(context); 
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. ÜST BİLGİ KARTI (Doluluk Durumu)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Text(
                    'Anlık Doluluk',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '% 45', // Burası ileride veritabanından gelecek
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '45 / 100 Araç',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. MENÜ BUTONLARI (Izgara Yapısı)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Yan yana 2 kutu olsun
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // BU KISMI:
                  _menuKarti(
                    icon: Icons.directions_car,
                    title: 'Araç Girişi',
                    color: Colors.green,
                    onTap: () {
                      // Buradaki debugPrint'i siliyoruz, yerine sayfa geçişi yazıyoruz:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VehicleEntryScreen()),
                      );
                    },
                  ),
                 _menuKarti(
                    icon: Icons.payment,
                    title: 'Araç Çıkışı',
                    color: Colors.red,
                    onTap: () {
                      // Çıkış Sayfasına Git
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VehicleExitScreen()),
                      );
                    },
                  ),
                 _menuKarti(
                    icon: Icons.history,
                    title: 'Geçmiş',
                    color: Colors.orange,
                    onTap: () {
                      // Geçmiş Sayfasına Git
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoryScreen()),
                      );
                    },
                  ),
                  _menuKarti(
                    icon: Icons.settings,
                    title: 'Ayarlar',
                    color: Colors.blueGrey,
                    onTap: () {
                       // Ayarlar Sayfasına Git
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
               ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tekrar eden kart kodlarını buraya fonksiyon olarak aldık (Clean Code)
  Widget _menuKarti({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}