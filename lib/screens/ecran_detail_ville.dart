import 'package:flutter/material.dart';
import '../models/ville.dart';
import '../models/meteo_dart.dart';

class EcranDetailVille extends StatelessWidget {
  final Ville ville;
  final MeteoData? meteo;

  const EcranDetailVille({super.key, required this.ville, this.meteo});

  IconData _iconeMeteo(String condition) {
    switch (condition) {
      case 'Ensoleille': return Icons.sunny;
      case 'Nuageux': return Icons.cloud;
      case 'Pluvieux': return Icons.umbrella;
      case 'Orageux': return Icons.thunderstorm;
      case 'Ventueux': return Icons.air;
      case 'Canicule': return Icons.sunny;
      default: return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ville.nom),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Le meme tag que sur l'ecran d'accueil !
            Hero(
              tag: 'icone-${ville.nom}',
              child: Icon(
                _iconeMeteo(ville.condition),
                size: 180,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              ville.nom,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              ville.pays,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (meteo != null)
              ...[
                Text(
                  '${meteo!.temperature.toStringAsFixed(1)} C',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  '${meteo!.conditionTexte} - ${meteo!.humidite}% humidite',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ]
            else
              const Text('Meteo non disponible'),
          ],
        ),
      ),
    );
  }
}