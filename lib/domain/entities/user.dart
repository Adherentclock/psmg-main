class User {
  final int id;
  final String nombre;
  final String paterno;
  final String materno;
  final String correo;
  final String contrasena;
  final dynamic emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  User({
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
}
