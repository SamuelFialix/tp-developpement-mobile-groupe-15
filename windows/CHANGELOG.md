## [1.0.0] - 2026-06-26

### Nouvelles fonctionnalites
- Affichage de la meteo en temps reel (Open-Meteo)
- Gestion d'etat avec Provider + MVVM
- Support de plusieurs villes : Cotonou, Parakou, Lagos, Abidjan, Abuja, Yamoussoukro, Paris
- Ajout de villes personnalisees
- Photo de ville personnalisable (galerie + camera)
- Localisation GPS pour trouver la ville la plus proche
- Notifications d'alerte chaleur (T > 33 C)
- Notification quotidienne planifiee (rappel meteo du jour)
- Animations : fondu au demarrage, transition Hero, AnimatedSwitcher sur la temperature
- Cache meteo (30 minutes) pour limiter les appels reseau
- Tests unitaires (modele MeteoData), tests du ViewModel et tests de widgets