import 'dart:convert' as convert;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:psmg/config/address/address.dart';
import 'package:psmg/infrastructure/models/informacion_medica/informacion_medica_model.dart';

class GetInformacionMedica {
  final storage = const FlutterSecureStorage();
  final Address address = Address();

  Future<dynamic> getInformacionMedica() async {
    final String? token = await storage.read(key: 'token');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url =
        Uri.http(address.getAddress(), '/api/visualizar-informacion-medica');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final map = convert.jsonDecode(response.body) as Map<String, dynamic>;
      final informacionMedicaModel = InformacionMedicaModel.fromJson(map);

      return informacionMedicaModel.toInformacionMedicaEntity();
    } else {
      return 'SR'; //SIN REGISTRO
    }
  }
}
