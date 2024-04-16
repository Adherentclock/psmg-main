import 'package:psmg/domain/entities/informacion_medica.dart';

class InformacionMedicaModel {
  final int id;
  final String sexo;
  final DateTime fechaNacimiento;
  final double peso;
  final double estatura;
  final int diabetes;
  final int obesidad;
  final int hipertension;
  final int usuarioId;
  final DateTime createdAt;
  final DateTime updatedAt;

  InformacionMedicaModel({
    required this.id,
    required this.sexo,
    required this.fechaNacimiento,
    required this.peso,
    required this.estatura,
    required this.diabetes,
    required this.obesidad,
    required this.hipertension,
    required this.usuarioId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InformacionMedicaModel.fromJson(Map<String, dynamic> json) =>
      InformacionMedicaModel(
        id: json["id"],
        sexo: json["sexo"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        peso: double.parse(json["peso"]),
        estatura: double.parse(json["estatura"]),
        diabetes: json["diabetes"],
        obesidad: json["obesidad"],
        hipertension: json["hipertension"],
        usuarioId: json["usuario_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sexo": sexo,
        "fecha_nacimiento":
            "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
        "peso": peso,
        "estatura": estatura,
        "diabetes": diabetes,
        "obesidad": obesidad,
        "hipertension": hipertension,
        "usuario_id": usuarioId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
  InformacioMedica toInformacionMedicaEntity() => InformacioMedica(
      id: id,
      sexo: sexo,
      fechaNacimiento: fechaNacimiento,
      peso: peso,
      estatura: estatura,
      diabetes: diabetes,
      obesidad: obesidad,
      hipertension: hipertension,
      usuarioId: usuarioId,
      createdAt: createdAt,
      updatedAt: updatedAt);
}
