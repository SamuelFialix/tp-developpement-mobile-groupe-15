import 'package:app_meteo/models/meteo_dart.dart';
import 'package:app_meteo/services/meteo_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/ville.dart';

class VilleViewModel extends ChangeNotifier {
  List<Ville> _villes = [];
  Ville? _villeSelectionnee;

  List<Ville> get villes => _villes;

  Ville? get villeSelectionnee => _villeSelectionnee;

  // Cache : nom de ville -> (donnees meteo, date de chargement)
  final Map<String, (MeteoData, DateTime)> _cacheMeteo = {};
  static const Duration _dureeValiditeCache = Duration(minutes: 30);

  VilleViewModel() {
    _initialiser();
  }

  void mettreAJourPhoto(String cheminPhoto) {
    if (_villeSelectionnee == null) return;
    final index = _villes.indexWhere((v) => v.nom == _villeSelectionnee!.nom);
    if (index ==-1) return;
    _villes[index] = _villes[index].copierAvecPhoto(cheminPhoto);
    _villeSelectionnee = _villes[index];
    notifyListeners();
  }

  void _initialiser() {
    _villes = [
      Ville(nom: 'Cotonou',
          pays: 'Benin',
          temperature: 45,
          condition: 'Ensoleille',
          humidite: 75),
      Ville(nom: 'Parakou',
          pays: 'Benin',
          temperature: 32,
          condition: 'Ensoleille',
          humidite: 60),
      Ville(nom: 'Lagos',
          pays: 'Nigeria',
          temperature: 31,
          condition: 'Nuageux',
          humidite: 80),
      Ville(nom: 'Abidjan',
          pays: 'CI',
          temperature: 27,
          condition: 'Pluvieux',
          humidite: 85),
      Ville(nom: 'Abuja',
          pays: 'Nigeria',
          temperature: 30,
          condition: 'Orageux',
          humidite: 87),
      Ville(nom: 'Yamoussoukro',
          pays: 'CI',
          temperature: 6,
          condition: 'Ventueux',
          humidite: 95),
      Ville(nom: 'Paris',
          pays: 'France',
          temperature: 10,
          condition: 'Orageux',
          humidite: 25),
    ];
    _villeSelectionnee = _villes.first;
    notifyListeners();
    selectionnerVille(_villeSelectionnee!);
  }

  Future<void> _verifierAlerteChaleur() async {
    if (_meteoActuelle == null) return;
      if (_meteoActuelle!.temperature > 33) {
        final plugin = FlutterLocalNotificationsPlugin();
        const AndroidNotificationDetails details =
        AndroidNotificationDetails('canal_alerte', 'Alertes Meteo', importance: Importance.high, priority: Priority.high,);
        await plugin.show(1, 'Alerte chaleur !', 'Il fait ${_meteoActuelle!.temperature.toStringAsFixed(0)} C a ${_villeSelectionnee!.nom}', NotificationDetails(android: details),
      );
    }
  }

  void ajouterVille(Ville ville) {
    _villes.add(ville);
    notifyListeners();
  }

  final MeteoService _meteoService = MeteoService();
  MeteoData? _meteoActuelle;
  bool _chargement = false;
  String? _erreur;

  MeteoData? get meteoActuelle => _meteoActuelle;

  bool get chargement => _chargement;

  String? get erreur => _erreur;

  Future<void> selectionnerVille(Ville ville,
      {bool forcerRafraichissement = false}) async {
    _villeSelectionnee = ville;
    _erreur = null;

    // 1. On regarde si on a une entree en cache pour cette ville
    final entreeCache = _cacheMeteo[ville.nom];
    if (!forcerRafraichissement && entreeCache != null) {
      final (meteoEnCache, dateChargement) = entreeCache;
      final age = DateTime.now().difference(dateChargement);

      if (age < _dureeValiditeCache) {
        // Cache encore valide : on l'utilise, pas d'appel API
        print('[CACHE] ${ville.nom} : utilisation du cache (${age
            .inMinutes} min)');
        _meteoActuelle = meteoEnCache;
        _chargement = false;
        notifyListeners();
        return;
      }
    }

    // 2. Cache absent ou expire : on interroge l'API
    print('[CACHE] ${ville.nom} : cache absent/expire, appel API');
    _chargement = true;
    notifyListeners();

    final meteo = await _meteoService.getMeteo(ville.nom);

    if (meteo != null) {
      _meteoActuelle = meteo;
      _cacheMeteo[ville.nom] =
      (meteo, DateTime.now()); // on met a jour le cache
    } else {
      _erreur = 'Impossible de charger la meteo';
    }
    _chargement = false;
    notifyListeners();
  }
}
