import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:psmg/config/address/address.dart';

class RegisterUser {
  final Address address = Address();
  Future<String> registerUser(Map<String, dynamic> datos) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    var url = Uri.http(address.getAddress(), '/api/usuario');
    print(datos);
    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(datos),
    );
    final Map<String, dynamic> decodificado = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      return decodificado['msg'];
    } else {
      // Manejar errores de solicitud a la API (lanzar una excepción o registrar un error)
      return "No se pudo establecer conexion con el servidor, intente de nuevo";
    }
  }
}
