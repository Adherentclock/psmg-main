import 'package:flutter/material.dart';
import 'package:psmg/config/helpers/get_prediagnostico.dart';
import 'package:psmg/domain/entities/prediagnostico.dart';

class PrediagnosticoProvider extends ChangeNotifier {
  final ScrollController prediagnosticosScrollController = ScrollController();
  final GetPrediagnostico getPrediagnostico = GetPrediagnostico();

  List<Prediagnostico> _prediagnosticosList =
      []; // Use una variable privada para el almacenamiento en caché
  List<Prediagnostico> get prediagnosticosList =>
      _prediagnosticosList; // Accesor público

  Future<void> verPrediagnostico() async {
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
    final listadopre = await getPrediagnostico.getPrediagnsotico();
    _prediagnosticosList = listadopre;
    /*prefs.setStringList(
        'prediagnosticos',
        _prediagnosticosList
            .map((prediagnostico) => jsonEncode(prediagnostico.toJson()))
            .toList()); // Actualizar caché*/
    notifyListeners();
  }
}
