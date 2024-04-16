import 'package:flutter/material.dart';
import 'package:psmg/config/helpers/get_predignosticos_sin_seguimiento.dart';
import 'package:psmg/domain/entities/prediagnostico.dart';

class PrediagnosticosinSeguimientoProvider extends ChangeNotifier {
  final ScrollController prediagnosticosScrollController = ScrollController();
  final GetPrediagnosticosSinSeguimiento getPrediagnosticosSinSeguimiento =
      GetPrediagnosticosSinSeguimiento();

  List<Prediagnostico> _prediagnosticosSinSeguimientoList =
      []; // Use una variable privada para el almacenamiento en caché
  List<Prediagnostico> get prediagnosticosList =>
      _prediagnosticosSinSeguimientoList; // Accesor público

  Future<void> verPrediagnosticoSinSeguimiento() async {
    /*final prefs =
        await SharedPreferences.getInstance(); // Inicializar almacenamiento

    final cachedData = prefs.getStringList('prediagnosticos');
    if (cachedData != null && cachedData.isNotEmpty) {
      _prediagnosticosList = cachedData
          .map((json) => Prediagnostico.fromJson(jsonDecode(json)))
          .toList();
      notifyListeners();
      return; // Datos cargados del caché, no se necesita llamada a la API
    }*/

    // El caché está vacío o desactualizado, obtener nuevos datos
    final listadopre = await getPrediagnosticosSinSeguimiento
        .getPrediagnsoticosSinSeguimiento();
    _prediagnosticosSinSeguimientoList = listadopre;
    /*prefs.setStringList(
        'prediagnosticos',
        _prediagnosticosList
            .map((prediagnostico) => jsonEncode(prediagnostico.toJson()))
            .toList()); // Actualizar caché*/
    notifyListeners();
  }
}
