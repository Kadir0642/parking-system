import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // <--- BU SATIRI EKLE

void main() {
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