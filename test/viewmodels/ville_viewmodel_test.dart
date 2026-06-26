import 'package:flutter_test/flutter_test.dart';
import 'package:app_meteo/viewmodels/ville_viewmodel.dart';
import 'package:app_meteo/models/ville.dart';

void main() {

  late VilleViewModel vm;

  setUp(() {
    // Creer un ViewModel frais avant chaque test
    vm = VilleViewModel();
  });

  group('VilleViewModel', () {

    test('la liste initiale contient au moins 4 villes', () {
      expect(vm.villes.length, greaterThanOrEqualTo(4));
    });

    test('Cotonou est dans la liste initiale', () {
      final contientCotonou = vm.villes.any((v) => v.nom == 'Cotonou');
      expect(contientCotonou, isTrue);
    });

    test('selectionnerVille met a jour villeSelectionnee', () {
      // ARRANGE : trouver Lagos dans la liste
      final lagos = vm.villes.firstWhere((v) => v.nom == 'Lagos');

      // ACT
      vm.selectionnerVille(lagos);

      // ASSERT
      expect(vm.villeSelectionnee?.nom, equals('Lagos'));
    });

    // Completer : tester ajouterVille
    test('ajouterVille augmente la liste de 1', () {
      // ARRANGE
      final nombreInitial = vm.villes.length;
      final nouvelleVille = Ville(
        nom: 'Porto-Novo',
        pays: 'Benin',
        temperature: 29,
        condition: 'Ensoleille',
        humidite: 65,
      );

      // ACT
      vm.ajouterVille(nouvelleVille);

      // ASSERT
      expect(vm.villes.length, equals(nombreInitial + 1));
      expect(vm.villes.any((v) => v.nom == 'Porto-Novo'), isTrue);
    });

    // Completer : tester que notifyListeners est appele
    test('selectionnerVille notifie les listeners', () {
      // ARRANGE
      var compteur = 0;
      vm.addListener(() => compteur++);
      final abidjan = vm.villes.firstWhere((v) => v.nom == 'Abidjan');

      // ACT
      vm.selectionnerVille(abidjan);

      // ASSERT : au moins une notification a eu lieu
      expect(compteur, greaterThan(0));
    });

  });
}