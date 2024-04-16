import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psmg/presentation/providers/prediagnostico_sin_seguimiento_provider.dart';
import 'package:psmg/presentation/widgets/expediente/prediagnostico_bubble.dart';

class SeguimientoView extends StatefulWidget {
  const SeguimientoView({super.key});

  @override
  State<SeguimientoView> createState() => _SeguimientoViewState();
}

class _SeguimientoViewState extends State<SeguimientoView> {
  int aux = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final PrediagnosticosinSeguimientoProvider
        prediagnosticoSinSeguimientoProvider =
        context.watch<PrediagnosticosinSeguimientoProvider>();
    void obtnPred() async {
      await prediagnosticoSinSeguimientoProvider
          .verPrediagnosticoSinSeguimiento();
    }

    if (aux == 0) {
      obtnPred();
    }
    setState(() {
      aux = 1;
    });

    return SafeArea(
      child: Column(
        children: [
          SpacerBox(size: size.height / 90),
          TitleModulo(size: size, colores: colors),
          SpacerBox(size: size.height / 70),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.004,
              bottom: size.height * 0.02,
            ),
            child: Container(
              width: size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                color: colors.secondary.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.7,
                      child: Text(
                        'Bienvenido al apartado de seguimiento médico, seleccione un prediagnóstico para realiza un formulario de seguimiento.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: size.height * 0.018,
                          color: Colors.black,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.016,
              bottom: size.height * 0.02,
            ),
            child: SubTitleModulo(size: size),
          ),
          Expanded(
            child:
                prediagnosticoSinSeguimientoProvider.prediagnosticosList.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: size.height * 0.06),
                        child: SizedBox(
                          width: size.width * 0.80,
                          child: const Text(
                            'No hay seguimientos por realizar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: prediagnosticoSinSeguimientoProvider
                            .prediagnosticosScrollController,
                        itemCount: prediagnosticoSinSeguimientoProvider
                            .prediagnosticosList.length,
                        itemBuilder: (context, index) {
                          final prediagnostico =
                              prediagnosticoSinSeguimientoProvider
                                  .prediagnosticosList[index];
                          final prediagnosticoNumber = index + 1;
                          print(prediagnosticoSinSeguimientoProvider
                              .prediagnosticosList.length);
                          return PrediagnosticoBubble(
                            isSeguimiento: true,
                            prediagnostico: prediagnostico,
                            prediagnosticoNumber: prediagnosticoNumber,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class TitleModulo extends StatelessWidget {
  const TitleModulo({super.key, required this.size, required this.colores});

  final Size size;
  final ColorScheme colores;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.7,
          child: Text(
            'Seguimiento Médico',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.height * 0.045,
              color: colores.primary,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class SubTitleModulo extends StatelessWidget {
  const SubTitleModulo({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Listado de Prediagnósticos',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: size.height * 0.021,
          color: Colors.black,
        ),
      ),
    );
  }
}

class SpacerBox extends StatelessWidget {
  const SpacerBox({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
    );
  }
}
