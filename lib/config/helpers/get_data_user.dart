import 'dart:convert' as convert;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:psmg/config/address/address.dart';
import 'package:psmg/infrastructure/models/user/user_model.dart';

class GetDataUser {
  final storage = const FlutterSecureStorage();
  final Address address = Address();

  Future<dynamic> getDataUser() async {
    final String? token = await storage.read(key: 'token');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Uri.http(address.getAddress(), '/api/usuario');
    var response = await http.get(url, headers: headers);
    final map = convert.jsonDecode(response.body) as Map<String, dynamic>;
    final userModel = UserModel.fromJson(map);

    return userModel.toUserEntity();
  }
}
