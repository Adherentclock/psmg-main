import 'package:flutter/material.dart';
import 'package:psmg/config/helpers/get_data_user.dart';
import 'package:psmg/domain/entities/user.dart';

class UserProvider extends ChangeNotifier {
  final GetDataUser getDataUser = GetDataUser();
  User userData = User(
      id: 0,
      nombre: "",
      paterno: "",
      materno: "",
      correo: "",
      contrasena: "",
      emailVerifiedAt: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now());

  Future<void> actUserData() async {
    final dataUser = await getDataUser.getDataUser();
    userData = dataUser;
    notifyListeners();
  }
}
