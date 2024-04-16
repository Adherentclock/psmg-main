class Prediagnostico {
  final int id;
  final int resultadoId;
  final String enfermedad;
  final int userId;
  final DateTime fechaPrediagnostico;
  final DateTime createdAt;
  final DateTime updatedAt;

  Prediagnostico({
    required this.id,
    required this.resultadoId,
    required this.enfermedad,
    required this.userId,
    required this.fechaPrediagnostico,
    required this.createdAt,
    required this.updatedAt,
  });
  Map<String, dynamic> toJson() => {
        "id": id,
        "resultadoId": resultadoId,
        "enfermedad": enfermedad,
        "usuario_id": userId,
        "fecha_prediagnostico": fechaPrediagnostico.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
  factory Prediagnostico.fromJson(Map<String, dynamic> json) => Prediagnostico(
        id: json["id"],
        resultadoId: json["resultadoId"],
        enfermedad: json["enfermedad"],
        userId: json["usuario_id"],
        fechaPrediagnostico: DateTime.parse(json["fecha_prediagnostico"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}
