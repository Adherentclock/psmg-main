import 'package:flutter/material.dart';
import 'package:psmg/config/helpers/get_informacion_medica.dart';
import 'package:psmg/domain/entities/informacion_medica.dart';

class InformacionMedicaProvider extends ChangeNotifier {
  final GetInformacionMedica getInformacionMedica = GetInformacionMedica();

  InformacioMedica informacionMedicaData = InformacioMedica(
      id: 0,
      sexo: "",
      fechaNacimiento: DateTime.now(),
      peso: 0.0,
      estatura: 0.0,
      diabetes: 0,
      obesidad: 0,
      hipertension: 0,
      usuarioId: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now());
  Future<void> actInfMedicaData() async {
    final dataInfMedica = await getInformacionMedica.getInformacionMedica();
    if (dataInfMedica == 'SR') {
      informacionMedicaData = InformacioMedica(
          id: 0,
          sexo: "",
          fechaNacimiento: DateTime.now(),
          peso: 0.0,
          estatura: 0.0,
          diabetes: 0,
          obesidad: 0,
          hipertension: 0,
          usuarioId: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
    } else {
      informacionMedicaData = dataInfMedica;
    }
    notifyListeners();
  }
}
