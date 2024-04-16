import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:psmg/config/address/address.dart';

class PostInformacionMedica {
  final Address address = Address();
  final storage = const FlutterSecureStorage();

  Future<String> registerInformacion(Map<String, dynamic> datos) async {
    var url =
        Uri.http(address.getAddress(), '/api/registrar-informacion-medica');
    print(datos);
    final String? token = await storage.read(key: 'token');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(datos),
    );
    print(response.body);
    final Map<String, dynamic> decodificado = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (decodificado['status'] == 0) {
        await storage.write(key: 'infData', value: 'no');
        return 'NO';
      } else {
        await storage.write(key: 'infData', value: 'si');
        return 'SI';
      }
    } else {
      // Manejar errores de solicitud a la API (lanzar una excepción o registrar un error)
      return "No se pudo establecer conexion con el servidor, intente de nuevo";
    }
  }
}
