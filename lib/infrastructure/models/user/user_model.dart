import 'package:psmg/domain/entities/user.dart';

class UserModel {
  final int id;
  final String nombre;
  final String paterno;
  final String materno;
  final String correo;
  final String contrasena;
  final dynamic emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.nombre,
    required this.paterno,
    required this.materno,
    required this.correo,
    required this.contrasena,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nombre: json["nombre"],
        paterno: json["paterno"],
        materno: json["materno"],
        correo: json["correo"],
        contrasena: json["contrasena"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "paterno": paterno,
        "materno": materno,
        "correo": correo,
        "contrasena": contrasena,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
  User toUserEntity() => User(
      id: id,
      nombre: nombre,
      paterno: paterno,
      materno: materno,
      correo: correo,
      contrasena: contrasena,
      emailVerifiedAt: emailVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt);
}
