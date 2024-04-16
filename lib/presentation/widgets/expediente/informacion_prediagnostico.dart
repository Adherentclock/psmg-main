import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:psmg/config/helpers/get_informacion_prediagnostico.dart';
import 'package:psmg/domain/entities/prediagnostico.dart';
import 'package:psmg/presentation/widgets/Styles/style.dart';
import 'package:psmg/presentation/widgets/expediente/draggable_sheet.dart';

class InformacionPrediagnostico {
  Future<dynamic> informacionPrediagnostico(BuildContext context, Size size,
      Prediagnostico prediagnostico, int prediagnosticoNumber) async {
    Map<String, dynamic> resultado = {};
    Future<void> obtUrl() async {
      final getInformacionPrediagnostico =
          GetInformacionPrediagnostico(idPrediagnostico: prediagnostico.id);
      resultado =
          await getInformacionPrediagnostico.getInformacionPrediagnostico();
    }

    await obtUrl();

    final imageUrl = '${resultado['urlImg']}.png'; // Replace with actual URL

    // ignore: use_build_context_synchronously
    final style = Style(context: context);
    final Map<int, String> preguntas = {
      1: '¿Experimenta algun sintoma nuevo desde que realizó su ultimo prediagnóstico?',
      2: '¿Ha notado algún cambio en la intensidad o frecuencia de sus síntomas?',
      3: '¿Ha ingerido algun medicamento? Si es así ¿Cual(es)?',
      4: '¿Ha realizado alguna prueba médica nueva desde su último prediagnóstico? Si es así, ¿cuáles fueron los resultados?',
      5: '¿Su situacion medica ha mejorado?',
    };
    final ColorScheme colors = Theme.of(context).colorScheme;

    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(imageUrl)); // Set timeout
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        return showDialog(
          context: context,
          builder: (context) => DraggableSheet(
            child: SizedBox(
              width: size.width - 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: Image.network(
                          imageUrl,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.52,
                        /*decoration: const BoxDecoration(
                          color: Colors.amberAccent,
                        ),*/
                        child: style.tituloPrediagBarra(
                            'Prediagnóstico $prediagnosticoNumber: ${prediagnostico.enfermedad}',
                            size.height * 0.025,
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
                            right: size.width * 0.05),
                        child: style.tituloPrediagBarra('Descripción: ',
                            size.height * 0.018, colors.secondary),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.05,
                            right: size.width * 0.05,
                            bottom: size.width * 0.05),
                        child: SizedBox(
                          width: size.width * 0.81,
                          child: Text(
                            resultado['informacion'],
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
                            'Sintomas presentados: ',
                            size.height * 0.018,
                            colors.secondary),
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
                            'Preguntas de Seguimiento: ',
                            size.height * 0.018,
                            colors.secondary),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.05, bottom: size.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (resultado["listSeguimiento"]['seg'])
                          for (var i = 1; i <= 5; i++)
                            if (resultado["listSeguimiento"]['pregunta_$i'] !=
                                null)
                              //Text(resultado["listSeguimiento"]['pregunta_$i']),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Agregar un título antes de cada pregunta
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: size.width * 0.05,
                                        bottom: size.width * 0.05),
                                    child: style.tituloPrediagBarra(
                                        '$i.- ${preguntas[i]!}',
                                        size.height * 0.012,
                                        colors.tertiary),
                                  ),

                                  // Mostrar la pregunta
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: size.width * 0.05),
                                    child: Text(resultado["listSeguimiento"]
                                        ['pregunta_$i']),
                                  ),
                                ],
                              ),
                        if (!resultado["listSeguimiento"]['seg'])
                          Row(
                            children: [
                              style.tituloPrediagBarra(
                                  'El usuario no ha realizado su seguimiento',
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
                            colors.secondary),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          bottom: size.width * 0.09,
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
                ],
              ),
            ),
          ),
        );
      } else {
        // Handle non-200 status codes (e.g., display error message)
      }
    } on SocketException {
      // Handle network exceptions
    } on TimeoutException {
      // Handle timeouts
    } catch (e) {
      // Handle other exceptions (e.g., display a placeholder image)
    }
  }
}
