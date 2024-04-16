import 'package:psmg/domain/entities/prediagnostico.dart';

class PrediagnosticoModel {
  final int id;
  final int resultadoId;
  final String enfermedad;
  final int usuarioId;
  final DateTime fechaPrediagnostico;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrediagnosticoModel({
    required this.id,
    required this.resultadoId,
    required this.enfermedad,
    required this.usuarioId,
    required this.fechaPrediagnostico,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrediagnosticoModel.fromJson(Map<String, dynamic> json) =>
      PrediagnosticoModel(
        id: json["id"],
        resultadoId: json["resultado_id"],
        enfermedad: json["enfermedad"],
        usuarioId: json["usuario_id"],
        fechaPrediagnostico: DateTime.parse(json["fecha_prediagnostico"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "resultado_id": resultadoId,
        "enfermedad": enfermedad,
        "usuario_id": usuarioId,
        "fecha_prediagnostico": fechaPrediagnostico.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
  Prediagnostico toPrediagnosticoEntity() => Prediagnostico(
        id: id,
        resultadoId: resultadoId,
        enfermedad: enfermedad,
        userId: usuarioId,
        fechaPrediagnostico: fechaPrediagnostico,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
