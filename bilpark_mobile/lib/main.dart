import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/otopark_servisi.dart'; // Servisi import etmeyi unutma

void main() async {
  // Flutter motorunu başlat (Async işlemler için gerekli)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Eski kayıtları yükle
  await OtoparkServisi().verileriYukle();
  
  runApp(const BilParkApp());
}


class BilParkApp extends StatelessWidget {
  const BilParkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BilPark',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const LoginScreen(), // <--- BURAYI DEĞİŞTİRDİK
    );
  }
}
// Aşağıdaki class AnaSayfa... kodlarını tamamen silebilirsin, artık ihtiyacımız yok.