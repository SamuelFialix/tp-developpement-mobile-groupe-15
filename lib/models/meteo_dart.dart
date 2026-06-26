import 'package:app_meteo/models/prevision_jour.dart';

class MeteoData {
  final double temperature;
  final int humidite;
  final int weatherCode;
  final String heure;
  final List<PrevisionJour> previsions;

  MeteoData({
    required this.temperature,
    required this.humidite,
    required this.weatherCode,
    required this.heure,
    required this.previsions,
  });

  factory MeteoData.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    final List<dynamic> dates = daily['time'];
    final List<PrevisionJour> listePrevisions = [];
    for (int i = 1; i < dates.length && listePrevisions.length < 3; i++) {
      listePrevisions.add(PrevisionJour.fromJson(daily, i));
    }
    return MeteoData(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidite: (current['relative_humidity_2m'] as num).toInt(),
      weatherCode: (current['weathercode'] as num).toInt(),
      heure: current['time'] as String,
      previsions: listePrevisions,
    );
  }

  String get conditionTexte {
    if (weatherCode == 0) return 'Ensoleille';
    if (weatherCode <= 3) return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Averses';
    if (weatherCode >= 95) return 'Orageux';
    return 'Variable';
  }

  bool estDangereux() {
    return temperature > 40 || weatherCode >= 95;
  }

  String get heureFormatee {
    final dt = DateTime.parse(heure);
    final jour = dt.day.toString().padLeft(2, '0');
    final mois = dt.month.toString().padLeft(2, '0');
    final annee = dt.year.toString();
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return 'Mesure du $jour/$mois/$annee à ${h}h$m';
  }
}
