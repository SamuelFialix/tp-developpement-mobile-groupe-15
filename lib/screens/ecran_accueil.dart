import 'package:app_meteo/screens/ecran_liste_villes.dart';
import 'package:app_meteo/viewmodels/ville_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_liste_villes.dart';

class  EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

  IconData _iconeMeteo(String  condition){
    switch (condition){
      case 'Ensoleille': return Icons.sunny;
      case 'Nuageux': return Icons.cloud;
      case 'Pluvieux': return Icons.umbrella;
      case 'Orageux': return Icons.thunderstorm;
      case 'Ventueux': return Icons.air;
      case 'Canicule' : return Icons.sunny;
      default        : return Icons.wb_cloudy;
    }
  }
  Color _obtenirCouleurMeteo(String? condition){
    switch (condition){
      case 'Ensoleille': return Colors.orange.shade100;
      case 'Nuageux': return Colors.grey.shade300;
      case 'Pluvieux': return Colors.blue.shade100;
      default        : return Colors.white;
    }
  }
  @override
  Widget build(BuildContext context){
    final vm = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;
    final couleurFond =  _obtenirCouleurMeteo(ville?.condition);

    return Scaffold(
      appBar: AppBar(
        title: Text('AppMeteo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ville == null
          ? Center(child:  CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: couleurFond,
              ),
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _iconeMeteo(ville.condition),
                        size: 100,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 16,),
                      Consumer<VilleViewModel>(
                          builder: (context, vm, _){
                            if(vm.chargement){
                              return CircularProgressIndicator();
                            }
                            if(vm.erreur != null){
                              return Column(children: [
                                Icon(Icons.wifi_off, size: 60, color: Colors.red),
                                Text(vm.erreur!, style: TextStyle(color: Colors.red),),
                                ElevatedButton(
                                  onPressed: () => vm.selectionnerVille(vm.villeSelectionnee!, forcerRafraichissement: true),
                                  child: Text('Reessayer'),
                                ),
                              ]);
                            }
                            final meteo = vm.meteoActuelle;
                            if(meteo == null) return Text('Chargement...');

                            return Column(children: [
                              Text(
                                '${meteo.temperature.toStringAsFixed(1)} C',
                                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold,)
                              ),
                              Text(
                                meteo.heureFormatee,
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              ),
                              Text('${meteo.conditionTexte} - ${meteo.humidite}%humidite'),
                              //Image.asset('assets/images/amaz.jpg', width: 60, height: 60,),
                              SizedBox(height: 20),
                              SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: meteo.previsions.length,
                                  itemBuilder: (context, index) {
                                    final prevision = meteo.previsions[index];
                                    return Container(
                                      width: 85,
                                      margin: EdgeInsets.symmetric(horizontal: 6),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(prevision.jourFormate, style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 4),
                                          Icon(_iconeMeteo(prevision.conditionTexte), color: Colors.orange, size: 28),
                                          SizedBox(height: 4),
                                          Text('${prevision.tempMax.toStringAsFixed(0)}°', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text('${prevision.tempMin.toStringAsFixed(0)}°', style: TextStyle(color: Colors.grey)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ]);
                          },
                      ),
                      SizedBox(height: 32),
                      ElevatedButton.icon(
                        icon: Icon(Icons.list),
                        label: Text('Changer de ville'),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EcranListeVilles(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
      )

    );

  }
}
