class PrevisionJour {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;

  PrevisionJour({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });

  factory PrevisionJour.fromJson(Map<String, dynamic> daily, int index) {
    return PrevisionJour(
      date: DateTime.parse(daily['time'][index]),
      tempMax: (daily['temperature_2m_max'][index] as num).toDouble(),
      tempMin: (daily['temperature_2m_min'][index] as num).toDouble(),
      weatherCode: (daily['weathercode'][index] as num).toInt(),
    );
  }

  String get jourFormate {
    const jours = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return jours[date.weekday - 1];
  }

  String get conditionTexte {
    if (weatherCode == 0) return 'Ensoleille';
    if (weatherCode <= 3) return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Averses';
    if (weatherCode >= 95) return 'Orageux';
    return 'Variable';
  }
}
