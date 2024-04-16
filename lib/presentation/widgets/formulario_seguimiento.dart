import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:psmg/config/helpers/get_informacion_prediagnostico.dart';
import 'package:psmg/config/helpers/post_seguimiento.dart';
import 'package:psmg/domain/entities/prediagnostico.dart';
import 'package:psmg/presentation/widgets/Styles/style.dart';
import 'package:psmg/presentation/widgets/expediente/draggable_sheet.dart';

class FormularioSeguimiento {
  Future<dynamic> formularioSeguimiento(
    BuildContext context,
    Size size,
    Prediagnostico prediagnostico,
    int prediagnosticoNumber,
    ColorScheme colors,
  ) async {
    Map<String, dynamic> resultado = {};
    Future<void> obtUrl() async {
      final getInformacionPrediagnostico =
          GetInformacionPrediagnostico(idPrediagnostico: prediagnostico.id);
      resultado =
          await getInformacionPrediagnostico.getInformacionPrediagnostico();
    }

    await obtUrl();

    // void showToast(String message) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: CustomToast(
    //         message: message,
    //         colors: colors,
    //       ),
    //       backgroundColor: Colors.transparent, // Make background transparent
    //       elevation: 0.0, // Remove elevation shadow
    //       duration: const Duration(seconds: 3), // Set duration (optional)
    //     ),
    //   );
    // }
    void showToast(String message) {
      Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: colors.primary,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    // ignore: use_build_context_synchronously
    final style = Style(context: context);
    final Map<int, String> preguntas = {
      1: '¿Experimenta algun sintoma nuevo desde que realizó su ultimo prediagnóstico?',
      2: '¿Ha notado algún cambio en la intensidad o frecuencia de sus síntomas?',
      3: '¿Ha ingerido algun medicamento? Si es así ¿Cual(es)?',
      4: '¿Ha realizado alguna prueba médica nueva desde su último prediagnóstico? Si es así, ¿cuáles fueron los resultados?',
      5: '¿Su situacion medica ha mejorado?',
    };
    final TextEditingController preg1 = TextEditingController();
    final TextEditingController preg2 = TextEditingController();
    final TextEditingController preg3 = TextEditingController();
    final TextEditingController preg4 = TextEditingController();
    final TextEditingController preg5 = TextEditingController();
    final PostSeguimiento postSeguimiento =
        PostSeguimiento(); // Track button state
    String textobtn = 'Enviar';
    void navegarPantallaSeguimiento() {
      Navigator.of(context).pushNamed("/main");
    }

    void enviar() async {
      Map<String, dynamic> datos = {
        "prediagnostico_id": prediagnostico.id,
        "pregunta_1": preg1.text,
        "pregunta_2": preg2.text,
        "pregunta_3": preg3.text,
        "pregunta_4": preg4.text,
        "pregunta_5": preg5.text,
      };
      final String respuesta = await postSeguimiento.registerSeguimiento(datos);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(respuesta)));

      if (respuesta == "Guardado") {
        showToast('Seguimiento Registrado');
        navegarPantallaSeguimiento();
      } else {
        showToast('Error al registrar');
      }
    }

    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DraggableSheet(
          child: SingleChildScrollView(
            child: SizedBox(
              width: size.width - 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.013),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: size.width - 60,
                            /*decoration: const BoxDecoration(
                                color: Colors.amberAccent,
                              ),*/
                            child: Text(
                              'FORMULARIO DE SEGUIMIENTO',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: size.height * 0.032,
                                color: colors.primary,
                              ),
                              softWrap: true,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.05,
                      right: size.width * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width - 60,
                          child: Text(
                            'Prediagnóstico: ${prediagnostico.enfermedad}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: size.height * 0.025,
                              color: colors.secondary,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.05,
                            bottom: size.width * 0.05,
                            top: size.height * 0.019),
                        child: style.tituloPrediagBarra(
                            'Sintomas presentados: ',
                            size.height * 0.018,
                            Colors.black),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.05, bottom: size.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (resultado["listSintomas"]['sin'])
                          for (var i = 1;
                              i <= resultado["listSintomas"].length;
                              i++)
                            if (resultado["listSintomas"]['$i'] != null)
                              Text('  * ${resultado["listSintomas"]['$i']}'),
                        if (!resultado["listSintomas"]['sin'])
                          Row(
                            children: [
                              style.tituloPrediagBarra(
                                  'El usuario no registró sintomas',
                                  size.height * 0.015,
                                  Colors.red),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.05, bottom: size.width * 0.05),
                        child: style.tituloPrediagBarra(
                            'Fecha del Prediagnóstico: ',
                            size.height * 0.018,
                            Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          bottom: size.width * 0.05,
                        ),
                        child: SizedBox(
                          width: size.width * 0.81,
                          child: Text(
                            '${prediagnostico.fechaPrediagnostico.day} de ${DateFormat('MMMM').format(prediagnostico.fechaPrediagnostico)} del ${prediagnostico.fechaPrediagnostico.year}',
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.05, bottom: size.width * 0.05),
                        child: style.tituloPrediagBarra(
                            'Preguntas de Seguimiento: ',
                            size.height * 0.018,
                            colors.primary),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          bottom: size.width * 0.05,
                          right: size.width * 0.05,
                        ),
                        child: SizedBox(
                          width: size.width * 0.81,
                          child: style.tituloPrediagBarra(
                            '1.- ${preguntas[1]!}',
                            size.height * 0.015,
                            colors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InputsData(
                    size: size,
                    textLabel: '',
                    controllerData: preg1,
                    ocultar: false,
                    colors: colors,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio.';
                      } else if (value.length > 200) {
                        return 'Este campo no puede tener más de 200 caracteres.';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.width * 0.05,
                          left: size.width * 0.05,
                          bottom: size.width * 0.05,
                          right: size.width * 0.05,
                        ),
                        child: SizedBox(
                          width: size.width * 0.81,
                          child: style.tituloPrediagBarra(
                            '2.- ${preguntas[2]!}',
                            size.height * 0.015,
                            colors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InputsData(
                    size: size,
                    textLabel: '',
                    controllerData: preg2,
                    ocultar: false,
                    colors: colors,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio.';
                      } else if (value.length > 200) {
                        return 'Este campo no puede tener más de 200 caracteres.';
                      }
                      return null; 
                    },
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.width * 0.05,
                          left: size.width * 0.05,
                          bottom: size.width * 0.05,
                          right: size.width * 0.05,
                        ),
                        child: SizedBox(
                          width: size.width * 0.81,
                          child: style.tituloPrediagBarra(
                            '3.- ${preguntas[3]!}',
                            size.height * 0.015,
                            colors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InputsData(
                    size: size,
                    textLabel: '',
                    controllerData: preg3,
                    ocultar: false,
                    colors: colors,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio.';
                      } else if (value.length > 200) {
                        return 'Este campo no puede tener más de 200 caracteres.';
                      }
                      return null; 
                    },
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.width * 0.05,
                          left: size.width * 0.05,
                          bottom: size.width * 0.05,
                          right: size.width * 0.05,
                        ),
                        child: SizedBox(
                          width: size.width * 0.81,
                          child: style.tituloPrediagBarra(
                            '4.- ${preguntas[4]!}',
                            size.height * 0.015,
                            colors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InputsData(
                    size: size,
                    textLabel: '',
                    controllerData: preg4,
                    ocultar: false,
                    colors: colors,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio.';
                      } else if (value.length > 200) {
                        return 'Este campo no puede tener más de 200 caracteres.';
                      }
                      return null; 
                    },
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.width * 0.05,
                          left: size.width * 0.05,
                          bottom: size.width * 0.05,
                          right: size.width * 0.05,
                        ),
                        child: SizedBox(
                          width: size.width * 0.81,
                          child: style.tituloPrediagBarra(
                            '5.- ${preguntas[5]!}',
                            size.height * 0.015,
                            colors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.02),
                    child: InputsData(
                      size: size,
                      textLabel: '',
                      controllerData: preg5,
                      ocultar: false,
                      colors: colors,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio.';
                        } else if (value.length > 200) {
                          return 'Este campo no puede tener más de 200 caracteres.';
                        }
                        return null; 
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.3),
                    child: Center(
                      child: SizedBox(
                        width: size.width * 0.7,
                        child: ElevatedButton(
                          onPressed: enviar,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(textobtn),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputsData extends StatelessWidget {
  const InputsData({
    super.key,
    required this.size,
    required this.textLabel,
    required this.controllerData,
    required this.ocultar,
    required this.colors,
    required this.validator,
  });

  final Size size;
  final TextEditingController controllerData;
  final String textLabel;
  final bool ocultar;
  final ColorScheme colors;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
      child: Card(
        child: Container(
          width: size.width * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            maxLines: 3,
            obscureText: ocultar,
            controller: controllerData,
            cursorOpacityAnimates: true,
            keyboardType: TextInputType.text,
            style: TextStyle(
              // Add style property for text entered
              fontSize:
                  size.height * 0.016, // Set desired font size for entered text
            ),
            decoration: InputDecoration(
              labelText: textLabel,
              contentPadding: const EdgeInsets.all(
                  10.0), // Adjust padding for desired spacing
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colors.primary,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomToast extends StatelessWidget {
  final String message;
  final ColorScheme colors;
  const CustomToast({
    super.key,
    required this.message,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: colors.primary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/Logo.png', height: 24.0),
          const SizedBox(width: 10.0),
          SizedBox(
              child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          )),
        ],
      ),
    );
  }
}
