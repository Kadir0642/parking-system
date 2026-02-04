import '../models/arac.dart';

class OtoparkServisi {
  // Singleton Yapısı (Her yerden aynı listeye ulaşmak için)
  static final OtoparkServisi _instance = OtoparkServisi._internal();
  factory OtoparkServisi() => _instance;
  OtoparkServisi._internal();

  // ARAÇ LİSTEMİZ (Veritabanı niyetine şimdilik burayı kullanacağız)
  final List<Arac> _araclar = [];

  // 1. Araç Ekleme
  void aracGiris(String plaka, String tip) {
    _araclar.insert(0, Arac( // En başa ekle
      plaka: plaka.toUpperCase(), // Plakayı hep büyük harf yap
      tip: tip,
      girisSaati: DateTime.now(),
    ));
  }

  // 2. Plaka Sorgulama (İçerdeki aracı bul)
  Arac? aracBul(String plaka) {
    try {
      return _araclar.firstWhere(
        (arac) => arac.plaka == plaka.toUpperCase() && arac.icerdeMi == true
      );
    } catch (e) {
      return null; // Bulamazsa null döner
    }
  }

  // 3. Araç Çıkış ve Ücret Hesaplama
  void aracCikis(Arac arac, double saatlikUcret) {
    arac.cikisSaati = DateTime.now();
    arac.icerdeMi = false;
    
    // Süreyi hesapla (Dakika cinsinden)
    Duration sure = arac.cikisSaati!.difference(arac.girisSaati);
    double saat = sure.inMinutes / 60.0;
    
    // Eğer 15 dakikadan az kaldıysa ücretsiz olsun (Kıyak geçelim)
    if (saat < 0.25) {
      arac.ucret = 0;
    } else {
      // Yukarı yuvarlama mantığı (Örn: 1.1 saat ise 2 saat parası al)
      arac.ucret = (saat.ceil()) * saatlikUcret; 
    }
  }

  // 4. Tüm Listeyi Getir
  List<Arac> gecmisiGetir() {
    return _araclar;
  }
  
  // 5. İçerdeki Araç Sayısı
  int icerdekiAracSayisi() {
    return _araclar.where((arac) => arac.icerdeMi).length;
  }
}