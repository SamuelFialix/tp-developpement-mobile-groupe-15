import 'package:flutter_test/flutter_test.dart';
import 'package:app_meteo/models/meteo_dart.dart';

void main() {
  group('MeteoData', () {

    // Test 1 : verifier que fromJson parse correctement
    test('fromJson parse la temperature correctement', () {
      final json = {
        'current': {
          'temperature_2m': 29.5,
          'relative_humidity_2m': 70,
          'weathercode': 0,
          'time': '2026-06-26T12:00',
        },
        'daily': {
          'time': ['2026-06-26', '2026-06-27', '2026-06-28', '2026-06-29'],
          'temperature_2m_max': [30.0, 31.0, 29.0, 28.0],
          'temperature_2m_min': [22.0, 23.0, 21.0, 20.0],
          'weathercode': [0, 1, 61, 95],
        },
      };

      final meteo = MeteoData.fromJson(json);

      expect(meteo.temperature, equals(29.5));
    });

    // Test 2 : verifier conditionTexte pour code 0
    test('conditionTexte retourne Ensoleille pour code 0', () {
      final meteo = MeteoData(
        temperature: 30,
        humidite: 60,
        weatherCode: 0,
        heure: '2026-06-26T12:00',
        previsions: [],
      );
      expect(meteo.conditionTexte, equals('Ensoleille'));
    });

    // Test 3 : conditionTexte retourne Pluvieux pour code 61
    test('conditionTexte retourne Pluvieux pour code 61', () {
      // ARRANGE
      final meteo = MeteoData(
        temperature: 25,
        humidite: 80,
        weatherCode: 61,
        heure: '2026-06-26T12:00',
        previsions: [],
      );

      // ACT + ASSERT
      expect(meteo.conditionTexte, equals('Pluvieux'));
    });

    // Test 4 : fromJson parse correctement l'humidite
    test('fromJson parse l humidite correctement', () {
      // ARRANGE
      final json = {
        'current': {
          'temperature_2m': 27.0,
          'relative_humidity_2m': 85,
          'weathercode': 2,
          'time': '2026-06-26T12:00',
        },
        'daily': {
          'time': ['2026-06-26', '2026-06-27'],
          'temperature_2m_max': [28.0, 29.0],
          'temperature_2m_min': [21.0, 22.0],
          'weathercode': [2, 3],
        },
      };

      // ACT
      final meteo = MeteoData.fromJson(json);

      // ASSERT
      expect(meteo.humidite, equals(85));
    });

    // ===== Exercice A : tester tous les codes WMO (Facile) =====

    test('conditionTexte retourne Nuageux pour code 1', () {
      final meteo = MeteoData(
        temperature: 25, humidite: 50, weatherCode: 1,
        heure: '2026-06-26T12:00', previsions: [],
      );
      expect(meteo.conditionTexte, equals('Nuageux'));
    });

    test('conditionTexte retourne Nuageux pour code 3', () {
      final meteo = MeteoData(
        temperature: 25, humidite: 50, weatherCode: 3,
        heure: '2026-06-26T12:00', previsions: [],
      );
      expect(meteo.conditionTexte, equals('Nuageux'));
    });

    test('conditionTexte retourne Averses pour code 80', () {
      final meteo = MeteoData(
        temperature: 25, humidite: 50, weatherCode: 80,
        heure: '2026-06-26T12:00', previsions: [],
      );
      expect(meteo.conditionTexte, equals('Averses'));
    });

    test('conditionTexte retourne Averses pour code 82', () {
      final meteo = MeteoData(
        temperature: 25, humidite: 50, weatherCode: 82,
        heure: '2026-06-26T12:00', previsions: [],
      );
      expect(meteo.conditionTexte, equals('Averses'));
    });

    test('conditionTexte retourne Orageux pour code 95 et plus', () {
      final meteo = MeteoData(
        temperature: 25, humidite: 50, weatherCode: 95,
        heure: '2026-06-26T12:00', previsions: [],
      );
      expect(meteo.conditionTexte, equals('Orageux'));
    });

    test('conditionTexte retourne Variable pour un code inconnu', () {
      final meteo = MeteoData(
        temperature: 25, humidite: 50, weatherCode: 45,
        heure: '2026-06-26T12:00', previsions: [],
      );
      expect(meteo.conditionTexte, equals('Variable'));
    });

    // ===== Exercice B : tester estDangereux() (Moyen) =====

    test('estDangereux retourne true si chaud ET orage', () {
      final meteo = MeteoData(
        temperature: 42, humidite: 50, weatherCode: 95,
        heure: '2026-06-26T12:00', previsions: [],
      );
      expect(meteo.estDangereux(), isTrue);
    });

    test('estDangereux retourne true si chaud seul (T > 40)', () {
      final meteo = MeteoData(
        temperature: 41, humidite: 50, weatherCode: 0,
        heure: '2026-06-26T12:00', previsions: [],
      );
      expect(meteo.estDangereux(), isTrue);
    });

    test('estDangereux retourne true si orage seul (code >= 95)', () {
      final meteo = MeteoData(
        temperature: 28, humidite: 50, weatherCode: 96,
        heure: '2026-06-26T12:00', previsions: [],
      );
      expect(meteo.estDangereux(), isTrue);
    });

    test('estDangereux retourne false dans un cas normal', () {
      final meteo = MeteoData(
        temperature: 28, humidite: 50, weatherCode: 0,
        heure: '2026-06-26T12:00', previsions: [],
      );
      expect(meteo.estDangereux(), isFalse);
    });

  });
}