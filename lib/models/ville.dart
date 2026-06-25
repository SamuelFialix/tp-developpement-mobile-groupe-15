class Ville{

  final String  nom;
  final String pays;
  final double temperature;
  final String condition;
  final int humidite;

  Ville({
    required this.nom,
    required this.pays,
    required this.temperature,
    required this.condition,
    required this.humidite,
  });
}
/*
  Le fait de déclarer les propriétés de la classe Ville avec final
  signifie qu'elles sont immuables, elles ne peuvent pas changer après initialisation
*/