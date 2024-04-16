class InformacioMedica {
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

  InformacioMedica({
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
}
