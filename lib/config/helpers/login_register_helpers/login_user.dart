import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:psmg/config/address/address.dart';

class LoginUser {
  final Address address = Address();
  final storage = const FlutterSecureStorage();
  final headers = <String, String>{'Content-Type': 'application/json'};

  Future<String> loginUser(String correo, String contrasena) async {
    var url = Uri.http(address.getAddress(), '/api/login');

    final Map<String, dynamic> jsonData = {
      "correo": correo,
      "contrasena": contrasena,
    };

    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(jsonData),
    );
    final Map<String, dynamic> decodificado = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (decodificado['status'] != 2) {
        return decodificado['msg'];
      } else {
        await storage.write(key: 'token', value: decodificado['msg']);
        await storage.write(key: 'user', value: decodificado['si']);
        print(decodificado['msg']);
        return ('Sesión Iniciada');
      }
    } else {
      // Manejar errores de solicitud a la API (lanzar una excepción o registrar un error)
      return "No se pudo establecer conexion con el servidor, intente de nuevo";
    }
    //TODO: implemenatar el timer para cuando no se tenga conexion.
  }
}
