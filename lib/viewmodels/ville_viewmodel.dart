import 'package:flutter/foundation.dart';
import '../models/ville.dart';

class VilleViewModel extends ChangeNotifier{
  List<Ville> _villes = [];
  Ville? _villeSelectionnee;

  List<Ville> get villes => _villes;
  Ville? get villeSelectionnee  => _villeSelectionnee;

  VilleViewModel(){
    _initialiser();
  }
  void _initialiser(){
    _villes = [
      Ville(nom:'Cotonou', pays: 'Benin', temperature: 45, condition: 'Ensoleille', humidite: 75),
      Ville(nom:'Parakou', pays: 'Benin', temperature: 32, condition: 'Ensoleille', humidite: 60),
      Ville(nom:'Lagos', pays: 'Nigeria', temperature: 31, condition: 'Nuageux', humidite: 80),
      Ville(nom:'Abidjan', pays: 'CI', temperature: 27, condition: 'Pluvieux', humidite: 85),
      Ville(nom:'Abuja', pays: 'Nigeria', temperature: 30, condition: 'Orageux', humidite: 87),
      Ville(nom:'Yamoussoukro', pays: 'CI', temperature: 6, condition: 'Ventueux', humidite: 95),
      Ville(nom:'paris', pays: 'FR', temperature: 10, condition: 'Orageux', humidite: 25),

    ];
    _villeSelectionnee = _villes.first;
    notifyListeners();
  }
  void selectionnerVille(Ville ville){
    _villeSelectionnee =  ville;
    notifyListeners();
  }
  void ajouterVille(Ville ville){
    _villes.add(ville);
    notifyListeners();
  }
}