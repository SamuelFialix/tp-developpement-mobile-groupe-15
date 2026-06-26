import 'package:dio/dio.dart';
import '../models/meteo_dart.dart';

class MeteoService {
  static const Map<String, List<double>> _coords = {
    'Cotonou': [6.3703, 2.3912],
    'Parakou': [9.3370, 2.6283],
    'Lagos': [6.4541, 3.3947],
    'Abidjan': [5.3600, -4.0083],
    'Abuja': [9.0579, 7.4951],
    'Paris': [48.8566, 2.3522],
    'Yamoussoukro': [6.8266, -5.2893],
  };

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.open-meteo.com/v1',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  MeteoService(){
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      logPrint: (msg) => print('[DIO] $msg'),
    ));
  }

  Future<MeteoData?> getMeteo(String nomVille) async{
    final coords = _coords[nomVille];
    if(coords == null){
      print('Ville inconnue : $nomVille');
      return null;
    }
    try{
      final response = await _dio.get(
          '/forecast',
          queryParameters: {
            'latitude': coords[0],
            'longitude': coords[1],
            'current': 'temperature_2m,relative_humidity_2m,weathercode',
            'daily': 'temperature_2m_max,temperature_2m_min,weathercode',
            'timezone': 'Africa/Lagos',
          }
          );
      return MeteoData.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e){
      print('Erreur reseau : ${e.message}');
      return null;
    }  catch (e){
      print('Erreur parsing : $e');
      return null;
    }
  }
}