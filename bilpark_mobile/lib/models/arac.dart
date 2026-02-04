class Arac {
  String plaka;
  String tip; // Otomobil, Kamyonet vb.
  DateTime girisSaati;
  DateTime? cikisSaati; // Henüz çıkmadıysa null olabilir
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
}