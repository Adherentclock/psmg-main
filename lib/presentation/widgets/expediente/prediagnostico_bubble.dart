import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psmg/domain/entities/prediagnostico.dart';
import 'package:psmg/presentation/widgets/expediente/informacion_prediagnostico.dart';
import 'package:psmg/presentation/widgets/formulario_seguimiento.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrediagnosticoBubble extends StatelessWidget {
  Future<int> obtenerIndex() async {
    int counter = 0;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt('counter')!;
    return counter;
  }

  final bool isSeguimiento;
  final Prediagnostico prediagnostico;
  final int prediagnosticoNumber;

  const PrediagnosticoBubble({
    super.key,
    required this.isSeguimiento,
    required this.prediagnostico,
    required this.prediagnosticoNumber,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final InformacionPrediagnostico draggablePrediagnosticos =
        InformacionPrediagnostico();
    final FormularioSeguimiento draggableSeguimiento = FormularioSeguimiento();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          child: Container(
            height: size.height * 0.1,
            width: size.width - (size.width / 5),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: colors.primary.withOpacity(0.9),
                    radius: 20,
                    child: Image.asset('assets/images/prediagnostico.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width - (size.width / 2.3),
                      child: Text(
                        'Prediagnóstico $prediagnosticoNumber \n${prediagnostico.enfermedad}',
                        style: TextStyle(
                            color: Colors.white, fontSize: size.width * 0.04),
                      ),
                    ),
                    Text(
                      'Fecha de Prediagnostico: \n ${prediagnostico.fechaPrediagnostico.day} de ${DateFormat('MMMM').format(prediagnostico.fechaPrediagnostico)} del ${prediagnostico.fechaPrediagnostico.year}',
                      style: TextStyle(fontSize: size.width * 0.03),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            if (isSeguimiento) {
              draggableSeguimiento.formularioSeguimiento(
                context,
                size,
                prediagnostico,
                prediagnosticoNumber,
                colors,
              );
            } else {
              draggablePrediagnosticos.informacionPrediagnostico(
                  context, size, prediagnostico, prediagnosticoNumber);
            }
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
