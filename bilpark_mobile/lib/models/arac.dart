import 'dart:convert';

class Arac {
  String plaka;
  String tip;
  DateTime girisSaati;
  DateTime? cikisSaati;
  double ucret;
  bool icerdeMi;

  Arac({
    required this.plaka,
    required this.tip,
    required this.girisSaati,
    this.cikisSaati,
    this.ucret = 0,
    this.icerdeMi = true,
  });

  // 1. Nesneyi JSON'a (String'e) çeviren metot (Kaydederken lazım)
  Map<String, dynamic> toMap() {
    return {
      'plaka': plaka,
      'tip': tip,
      'girisSaati': girisSaati.toIso8601String(), // Tarihi yazıya çevir
      'cikisSaati': cikisSaati?.toIso8601String(),
      'ucret': ucret,
      'icerdeMi': icerdeMi,
    };
  }

  // 2. JSON'u (String'i) Nesneye çeviren metot (Okurken lazım)
  factory Arac.fromMap(Map<String, dynamic> map) {
    return Arac(
      plaka: map['plaka'],
      tip: map['tip'],
      girisSaati: DateTime.parse(map['girisSaati']), // Yazıyı tarihe çevir
      cikisSaati: map['cikisSaati'] != null ? DateTime.parse(map['cikisSaati']) : null,
      ucret: (map['ucret'] as num).toDouble(), // Sayı dönüşümü garantisi
      icerdeMi: map['icerdeMi'] ?? true,
    );
  }

  // Listeyi JSON String'e çevirmek için yardımcılar
  String toJson() => json.encode(toMap());
  factory Arac.fromJson(String source) => Arac.fromMap(json.decode(source));
}