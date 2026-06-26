import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  /// A appeler une seule fois au demarrage de l'app.
  static Future<void> initialiser() async {
    const AndroidInitializationSettings parametresAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings parametres =
    InitializationSettings(android: parametresAndroid);

    await _plugin.initialize(parametres);
  }

  /// Planifie la notification quotidienne a 7h00 avec periodicallyShow().
  static Future<void> planifierNotificationQuotidienne({
    String corps = 'Consultez la meteo du jour dans l\'application !',
  }) async {
    final maintenant = DateTime.now();
    DateTime prochain7h = maintenant.add(Duration(minutes: 2)); // TEST
    /*DateTime prochain7h = DateTime(
      maintenant.year, maintenant.month, maintenant.day, 7, 0, 0,
    );*/
    if (maintenant.isAfter(prochain7h)) {
      prochain7h = prochain7h.add(Duration(days: 1));
    }

    final delaiAvant7h = prochain7h.difference(maintenant);

    Future.delayed(delaiAvant7h, () async {
      await _plugin.periodicallyShow(
        0,
        'Meteo du jour',
        corps,
        RepeatInterval.daily,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'canal_meteo_quotidien',
            'Rappel meteo quotidien',
            channelDescription: 'Rappel chaque matin de la meteo prevue',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    });
  }
}