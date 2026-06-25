import 'package:app_meteo/screens/ecran_ajouter_ville.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import '../models/ville.dart';

class EcranListeVilles extends StatelessWidget {
  const EcranListeVilles({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VilleViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Choisir une ville'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: vm.villes.length,
        itemBuilder: (context, index){
          final ville = vm.villes[index];
          final estSelectionnee = ville.nom == vm.villeSelectionnee?.nom;
          return ListTile(
            leading: Icon(
              Icons.location_city,
              color: estSelectionnee ? Colors.blue : Colors.grey,
            ),
            title: Text(
              ville.nom,
              style: TextStyle(
                fontWeight: estSelectionnee
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            subtitle: Text('${ville.pays} - ${ville.temperature} C'),
            trailing: estSelectionnee
                ? Icon(Icons.check_circle, color: Colors.blue)
                : null,
            onTap: () {
              context.read<VilleViewModel>().selectionnerVille(ville);
              Navigator.pop(context);
            }
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EcranAjouterVille()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Ajouter'),
          ),
    );
  }
}