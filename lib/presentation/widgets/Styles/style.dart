import 'package:flutter/material.dart';

class Style {
  final BuildContext context;

  Style({required this.context});

  Widget textoEstilo(String texto, double size, Color color) {
    return Text(
      texto,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: size,
        color: color,
      ),
    );
  }

  Widget spacerBox(double size) {
    return SizedBox(
      height: size,
    );
  }

  Widget gradiantBackground(Size size, List<Color> colores) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: const Alignment(0.00, -1.00),
              end: const Alignment(0, 1),
              colors: colores)),
    );
  }

  Widget checkBoxPregunta(
      bool selectedValue, ValueChanged<bool?>? onChange, String titulo) {
    return CheckboxListTile(
      title: Text(titulo),
      value: selectedValue,
      onChanged: onChange,
    );
  }

  Widget textoDosEstilo(String texto, double size, Color color) {
    return Text(
      texto,
      style: TextStyle(
          fontFamily: 'Poppins',
          fontStyle: FontStyle.italic,
          fontSize: size,
          color: color),
    );
  }

  Widget tituloPrediagBarra(String texto, double size, color) {
    return Text(
      texto,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: size,
        color: color,
      ),
      softWrap: true,
    );
  }
}
