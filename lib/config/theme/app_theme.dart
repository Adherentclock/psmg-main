import 'package:flutter/material.dart';

const Color _customColor1 = Color.fromARGB(255, 136, 167, 208);
const Color _customColor2 = Color(0x0057bd9e);

const List<Color> _colorThemes = [
  _customColor1,
  _customColor2,
];

class AppTheme {
  final int selectedColor;

  AppTheme({required this.selectedColor})
      : assert(selectedColor >= 0 && selectedColor <= _colorThemes.length - 1,
            'El color seleccionado debe estar entre 0 y ${_colorThemes.length}');

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
