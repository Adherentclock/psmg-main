import 'dart:convert' as convert;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:psmg/config/address/address.dart';

class GetInformacionPrediagnostico {
  final int idPrediagnostico;

  GetInformacionPrediagnostico({
    required this.idPrediagnostico,
  });

  final storage = const FlutterSecureStorage();

  final Address address = Address();

  Future<Map<String, dynamic>> getInformacionPrediagnostico() async {
    final client = http.Client(); // Create a client instance
    try {
      final String dir = address.getAddress();
      final String? token = await storage.read(key: 'token');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var url =
          Uri.http(dir, '/api/informacion-prediagnostico/$idPrediagnostico');
      var response = await client.get(url, headers: headers);
      final Map<String, dynamic> decodificado =
          convert.jsonDecode(response.body);
      return decodificado;
    } finally {
      client.close();
      // Close the client (and its connections)
    }
  }
}

//TODO: REVISAR


  // Map<String, dynamic> resultado = {
  //   'imgInfo': 0,
  //   'sintomas': 0,
  //   'seguimiento': 0
  // };


      // if (response.statusCode == 200) {
    //   //imagen e informacion
    //   url = Uri.http(dir, '/api/sintomas-ver/$idPrediagnostico');
    //   response = await http.get(url, headers: headers);
    //   final Map<String, dynamic> decodificado1 =
    //       convert.jsonDecode(response.body) as Map<String, dynamic>;
    //   if (response.statusCode == 200) {
    //     //sintomas
    //     url = Uri.http(dir, '/api/seguimiento-ver/$idPrediagnostico');
    //     response = await http.get(url, headers: headers);
    //     final Map<String, dynamic> decodificado2 =
    //         convert.jsonDecode(response.body) as Map<String, dynamic>;
    //     if (response.statusCode == 200) {
    //       // seguimiento
    //       resultado = {
    //         'imgInfo': 1,
    //         'urlImg': "http://${decodificado["urlImg"]}",
    //         'informacion': decodificado["urlArch"],
    //         'sintomas': 1,
    //         'listSintomas': decodificado1,
    //         'seguimiento': 1,
    //         'listSeguimiento': decodificado2
    //       };
    //     } else {
    //       return;
    //     }
    //   } else {
    //     return;
    //   }
    // } else {
    //   return; //SIN REGISTRO
    // }