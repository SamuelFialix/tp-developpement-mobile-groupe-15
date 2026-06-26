import 'package:app_meteo/screens/ecran_liste_villes.dart';
import 'package:app_meteo/viewmodels/ville_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localisation_service.dart';
import '../services/meteo_service.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_liste_villes.dart';
import 'ecran_detail_ville.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EcranAccueil extends StatefulWidget {
  const EcranAccueil({super.key});

  @override
  State<EcranAccueil> createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  IconData _iconeMeteo(String condition) {
    switch (condition) {
      case 'Ensoleille':
        return Icons.sunny;
      case 'Nuageux':
        return Icons.cloud;
      case 'Pluvieux':
        return Icons.umbrella;
      case 'Orageux':
        return Icons.thunderstorm;
      case 'Ventueux':
        return Icons.air;
      case 'Canicule':
        return Icons.sunny;
      default:
        return Icons.wb_cloudy;
    }
  }

  Color _obtenirCouleurMeteo(String? condition) {
    switch (condition) {
      case 'Ensoleille':
        return Colors.orange.shade100;
      case 'Nuageux':
        return Colors.grey.shade300;
      case 'Pluvieux':
        return Colors.blue.shade100;
      default:
        return Colors.white;
    }
  }

  void _afficherChoixSourceImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext contexteModal) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galerie'),
                onTap: () async {
                  Navigator.pop(contexteModal);
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  ); // ✅
                  if (image != null)
                    context.read<VilleViewModel>().mettreAJourPhoto(image.path);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Appareil photo'),
                onTap: () async {
                  Navigator.pop(contexteModal);
                  print('Source choisie : camera');
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  ); // ⚠️ vérifie bien "camera" ici, pas "gallery"
                  if (image != null)
                    context.read<VilleViewModel>().mettreAJourPhoto(image.path);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formaterCoordonnees(String nomVille) {
    final coords = MeteoService.coordss[nomVille];
    if (coords == null) return '';
    final lat = coords[0];
    final lon = coords[1];
    final directionLat = lat >= 0 ? 'N' : 'S';
    final directionLon = lon >= 0 ? 'E' : 'O';
    return '${lat.abs().toStringAsFixed(4)}° $directionLat, ${lon.abs().toStringAsFixed(4)}° $directionLon';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;
    final couleurFond = _obtenirCouleurMeteo(ville?.condition);

    return Scaffold(
      appBar: AppBar(
        title: Text('AppMeteo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.my_location),
            label: Text('Trouver la ville la plus proche'),
            onPressed: () async {
              final service = LocalisationService();
              final position = await service.getPosition();
              if (position != null) {
                final vm = context.read<VilleViewModel>();
                final villeProche = service.trouverVilleProche(
                  position,
                  vm.villes,
                  MeteoService.coordss,
                );
                if (villeProche != null) {
                  vm.selectionnerVille(villeProche);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ville proche : ${villeProche.nom}'),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('GPS indisponible')));
              }
            },
          ),
        ],
      ),
      body: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
        child: ville == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(color: couleurFond),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ville.nom,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formaterCoordonnees(ville.nom),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EcranDetailVille(
                                  ville: ville,
                                  meteo: vm.meteoActuelle,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'icone-${ville.nom}',
                            child: Icon(
                              _iconeMeteo(ville.condition),
                              size: 80,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _afficherChoixSourceImage(context),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: vm.villeSelectionnee?.photoPath != null
                                ? Image.file(
                                    File(vm.villeSelectionnee!.photoPath!),
                                    width: double.infinity,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: Colors.grey[200],
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                        Text('Appuyez pour ajouter une photo'),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        Consumer<VilleViewModel>(
                          builder: (context, vm, _) {
                            if (vm.chargement) {
                              return CircularProgressIndicator();
                            }
                            if (vm.erreur != null) {
                              return Column(
                                children: [
                                  Icon(
                                    Icons.wifi_off,
                                    size: 60,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    vm.erreur!,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => vm.selectionnerVille(
                                      vm.villeSelectionnee!,
                                      forcerRafraichissement: true,
                                    ),
                                    child: Text('Reessayer'),
                                  ),
                                ],
                              );
                            }
                            final meteo = vm.meteoActuelle;
                            if (meteo == null) return Text('Chargement...');

                            return Column(
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    '${meteo.temperature.toStringAsFixed(1)} C',
                                    key: ValueKey(
                                      '${vm.villeSelectionnee?.nom}-${meteo.temperature}',
                                    ),
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  meteo.heureFormatee,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '${meteo.conditionTexte} - ${meteo.humidite}%humidite',
                                ),
                                //Image.asset('assets/images/amaz.jpg', width: 60, height: 60,),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 130,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: meteo.previsions.length,
                                    itemBuilder: (context, index) {
                                      final prevision = meteo.previsions[index];
                                      return Container(
                                        width: 85,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              prevision.jourFormate,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Icon(
                                              _iconeMeteo(
                                                prevision.conditionTexte,
                                              ),
                                              color: Colors.orange,
                                              size: 28,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '${prevision.tempMax.toStringAsFixed(0)}°',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${prevision.tempMin.toStringAsFixed(0)}°',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: Icon(Icons.list),
                          label: Text('Changer de ville'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EcranListeVilles(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
