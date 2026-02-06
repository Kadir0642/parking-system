import 'package:shared_preferences/shared_preferences.dart';
import '../models/arac.dart';

class OtoparkServisi {
  static final OtoparkServisi _instance = OtoparkServisi._internal();
  factory OtoparkServisi() => _instance;
  OtoparkServisi._internal();

  List<Arac> _araclar = [];

  // --- YENİ EKLENEN KISIM: VERİTABANI İŞLEMLERİ ---

  // 1. Verileri Telefona Kaydet
  Future<void> _verileriKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    // Listeyi JSON formatına çevirip string listesi olarak saklıyoruz
    final List<String> kayitlarJson = _araclar.map((arac) => arac.toJson()).toList();
    await prefs.setStringList('otopark_kayitlari', kayitlarJson);
  }

  // 2. Verileri Telefondan Yükle (Uygulama açılınca çağrılacak)
  Future<void> verileriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? kayitlarJson = prefs.getStringList('otopark_kayitlari');
    
    if (kayitlarJson != null) {
      _araclar = kayitlarJson.map((str) => Arac.fromJson(str)).toList();
    }
  }

  // --------------------------------------------------

  // Araç Ekleme (Artık async çünkü kayıt yapıyor)
  Future<void> aracGiris(String plaka, String tip) async {
    _araclar.insert(0, Arac(
      plaka: plaka.toUpperCase(),
      tip: tip,
      girisSaati: DateTime.now(),
    ));
    await _verileriKaydet(); // Değişikliği kaydet
  }

  Arac? aracBul(String plaka) {
    try {
      return _araclar.firstWhere(
        (arac) => arac.plaka == plaka.toUpperCase() && arac.icerdeMi == true
      );
    } catch (e) {
      return null;
    }
  }

  // Araç Çıkış (Artık async)
  Future<void> aracCikis(Arac arac, double saatlikUcret) async {
    arac.cikisSaati = DateTime.now();
    arac.icerdeMi = false;
    
    Duration sure = arac.cikisSaati!.difference(arac.girisSaati);
    double saat = sure.inMinutes / 60.0;
    
    if (saat < 0.25) {
      arac.ucret = 0;
    } else {
      arac.ucret = (saat.ceil()) * saatlikUcret; 
    }
    await _verileriKaydet(); // Değişikliği kaydet
  }

  List<Arac> gecmisiGetir() {
    return _araclar;
  }
  
  int icerdekiAracSayisi() {
    return _araclar.where((arac) => arac.icerdeMi).length;
  }
}