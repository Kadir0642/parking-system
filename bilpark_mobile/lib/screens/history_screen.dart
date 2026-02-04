import 'package:flutter/material.dart';
import '../services/otopark_servisi.dart';
import '../models/arac.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gerçek verileri servisten çek
    final List<Arac> kayitlar = OtoparkServisi().gecmisiGetir();

    return Scaffold(
      appBar: AppBar(
        title: const Text('İşlem Geçmişi'),
        backgroundColor: Colors.orange, // Tema rengi turuncu
        foregroundColor: Colors.white,
      ),
      body: kayitlar.isEmpty
          ? const Center(
              child: Text(
                "Henüz kayıt yok",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: kayitlar.length,
              itemBuilder: (context, index) {
                final arac = kayitlar[index];
                
                // Artık ['durum'] yok, icerdeMi değişkeni var.
                // Eğer içerde değilse (!icerdeMi), çıkış yapmış demektir.
                final bool cikisYapmis = !arac.icerdeMi;

                // Saati düzgün göstermek için (Örn: 9:5 yerine 09:05 yapmak için)
                final islemZamani = cikisYapmis ? arac.cikisSaati! : arac.girisSaati;
                final saatMetni = "${islemZamani.hour}:${islemZamani.minute.toString().padLeft(2, '0')}";

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cikisYapmis
                          ? Colors.red.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      child: Icon(
                        cikisYapmis ? Icons.output : Icons.login,
                        color: cikisYapmis ? Colors.red : Colors.green,
                      ),
                    ),
                    title: Text(
                      arac.plaka, // DÜZELTME: ['plaka'] yerine .plaka
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      cikisYapmis
                          ? "Çıkış Saati: $saatMetni"
                          : "Giriş Saati: $saatMetni",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          cikisYapmis ? "${arac.ucret} ₺" : "-", // DÜZELTME: Fiyat gösterimi
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: cikisYapmis ? Colors.black : Colors.grey,
                          ),
                        ),
                        Text(
                          cikisYapmis ? "Tahsil Edildi" : "İçeride",
                          style: TextStyle(
                              fontSize: 12,
                              color: cikisYapmis ? Colors.green : Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}