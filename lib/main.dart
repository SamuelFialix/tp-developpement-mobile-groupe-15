import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/ville_viewmodel.dart';
import 'screens/ecran_accueil.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialiser();
  await NotificationService.planifierNotificationQuotidienne();
  runApp(
    ChangeNotifierProvider(
        create:(_) => VilleViewModel(),
        child: MaterialApp(
          title: 'AppMeteo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: EcranAccueil(),
        ),
    ),
  );
}