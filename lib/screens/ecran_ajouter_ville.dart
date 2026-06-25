import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import '../models/ville.dart';

class EcranAjouterVille extends StatefulWidget{
  const EcranAjouterVille({super.key});

  @override
  State<EcranAjouterVille> createState() => _EcranAjouterVilleState();
}

class _EcranAjouterVilleState extends State<EcranAjouterVille> {
  final _nomController = TextEditingController();
  final _paysController = TextEditingController();
  final _tempController = TextEditingController();
  final _humiditeController = TextEditingController();

  String _conditionSelectionnee = 'Ensoleille';
  final List<String> _conditions = ['Ensoleille', 'Nuageux', 'Pluvieux', 'Orageux', 'Vertueux'];

  @override
  void dispose(){
    _nomController.dispose();
    _paysController.dispose();
    _tempController.dispose();
    _humiditeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une ville'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(labelText: 'Nom de la ville'),
                ),
                TextField(
                  controller: _paysController,
                  decoration: const InputDecoration(labelText: 'Pays'),
                ),
                TextField(
                  controller: _tempController,
                  decoration: const InputDecoration(labelText: 'Température (°C)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _humiditeController,
                  decoration: const InputDecoration(labelText: 'Humidité (%)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20,),
                DropdownButtonFormField<String>(
                    value: _conditionSelectionnee,
                    decoration: const InputDecoration(labelText: 'Condition météo'),
                    items: _conditions.map((String condition){
                      return DropdownMenuItem<String>(
                        value: condition,
                        child: Text(condition),
                      );
                    }).toList(),
                    onChanged: (String? nouvelleValeur){
                      setState(() {
                        _conditionSelectionnee = nouvelleValeur!;
                      });
                    },
                ),
                const SizedBox(height: 30,),
                ElevatedButton(
                    onPressed: (){
                      final double temp = double.tryParse(_tempController.text) ?? 0;
                      final int hum = int.tryParse(_humiditeController.text) ?? 0;
                      final nouvelleVille = Ville(
                        nom: _nomController.text,
                        pays: _paysController.text,
                        temperature: temp,
                        condition: _conditionSelectionnee,
                        humidite: hum,
                      );
                      Provider.of<VilleViewModel>(context, listen: false).ajouterVille(nouvelleVille);
                      Navigator.pop(context);
                    },
                    child: const Text('Valider et Créer'),
                ),
              ],
            ),
          )
      ),
    );
  }
}