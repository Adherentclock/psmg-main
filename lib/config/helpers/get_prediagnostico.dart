import 'dart:convert' as convert;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:psmg/config/address/address.dart';
import 'package:psmg/domain/entities/prediagnostico.dart';
import 'package:psmg/infrastructure/models/prediagnosticos/prediagnostico_model.dart';

class GetPrediagnostico {
  final Address address = Address();
  final storage = const FlutterSecureStorage();
  Future<dynamic> getPrediagnsotico() async {
    final String? token = await storage.read(key: 'token');
    var url = Uri.http(address.getAddress(), '/api/prediagnosticos');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.get(url, headers: headers);
    //print(response.body);
    if (response.statusCode == 200) {
      // Parsear la respuesta JSON
      final List<dynamic> datosDecodificados =
          convert.jsonDecode(response.body);

      // Asegurar que datosDecodificados sea una lista (manejar posibles errores)
      // Convertir cada objeto JSON en una instancia de PrediagnosticoModel
      final List<Prediagnostico> prediagnosticos =
          datosDecodificados.map((dynamic item) {
        return PrediagnosticoModel.fromJson(item as Map<String, dynamic>)
            .toPrediagnosticoEntity();
      }).toList();
      //print(prediagnosticos);
      return prediagnosticos; // Return the list of Prediagnostico objects
    } else {
      // Manejar errores de solicitud a la API (lanzar una excepción o registrar un error)
      throw Exception(
          'Error al obtener prediagnósticos: ${response.statusCode}');
    }
  }
}
