import 'package:flutter/material.dart';
import '../services/otopark_servisi.dart'; // Servisi çağırmak için
import 'vehicle_entry_screen.dart';
import 'vehicle_exit_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Canlı Veriler
  int _mevcutArac = 0;
  int _kapasite = 20; // Otoparkın toplam kapasitesi (Örn: 20 araçlık)
  
  @override
  void initState() {
    super.initState();
    // Ekran ilk açıldığında verileri çek
    _bilgileriGuncelle();
  }

  // Servisten güncel sayıları alıp ekranı boyayan fonksiyon
  void _bilgileriGuncelle() {
    setState(() {
      _mevcutArac = OtoparkServisi().icerdekiAracSayisi();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Doluluk oranını hesapla (Yüzde)
    double dolulukOrani = _mevcutArac / _kapasite;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('BilPark Panel'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _bilgileriGuncelle, // Manuel yenileme butonu
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. CANLI BİLGİ KARTI
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
              child: Column(
                children: [
                  const Text(
                    'Anlık Doluluk',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '% ${(dolulukOrani * 100).toStringAsFixed(0)}', // Yüzdeyi hesapla
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$_mevcutArac / $_kapasite Araç',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  // Doluluk Çubuğu (Progress Bar)
                  LinearProgressIndicator(
                    value: dolulukOrani,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      dolulukOrani > 0.9 ? Colors.red : Colors.green, // Dolunca kırmızı ol
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. MENÜ BUTONLARI
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _menuKarti(
                    icon: Icons.directions_car,
                    title: 'Araç Girişi',
                    color: Colors.green,
                    onTap: () async {
                      // Gidilen sayfadan dönünce verileri güncelle (await)
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VehicleEntryScreen()),
                      );
                      _bilgileriGuncelle(); 
                    },
                  ),
                  _menuKarti(
                    icon: Icons.payment,
                    title: 'Araç Çıkışı',
                    color: Colors.red,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VehicleExitScreen()),
                      );
                      _bilgileriGuncelle();
                    },
                  ),
                  _menuKarti(
                    icon: Icons.history,
                    title: 'Geçmiş',
                    color: Colors.orange,
                    onTap: () {
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}