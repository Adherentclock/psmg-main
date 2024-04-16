import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psmg/presentation/providers/informacion_medica_provider.dart';
import 'package:psmg/presentation/providers/prediagnostico_provider.dart';
import 'package:psmg/presentation/providers/user_provider.dart';
import 'package:psmg/presentation/widgets/expediente/prediagnostico_bubble.dart';

// ignore: must_be_immutable
class ExpedienteView extends StatefulWidget {
  const ExpedienteView({super.key});

  @override
  State<ExpedienteView> createState() => _ExpedienteViewState();
}

class _ExpedienteViewState extends State<ExpedienteView> {
  int aux = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final userData = userProvider.userData;
    final informacionMedicaProvider =
        context.watch<InformacionMedicaProvider>();
    final informacionData = informacionMedicaProvider.informacionMedicaData;
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final prediagnosticosProvider = context.watch<PrediagnosticoProvider>();
    void obtnPred() async {
      await prediagnosticosProvider.verPrediagnostico();
    }

    if (aux == 0) {
      obtnPred();
    }
    setState(() {
      aux = 1;
    });
    int calculateAge(DateTime birthDate, DateTime currentDate) {
      int age = currentDate.year - birthDate.year;

      // Check if birthday has not happened yet in the current year
      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        age--;
      }

      return age;
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SpacerBox(size: size.height / 90),
              TitleModulo(size: size, colores: colors),
              SpacerBox(size: size.height / 70),
              Container(
                width: size.width / 1.2,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Nombre: ${userData.nombre} ${userData.paterno} ${userData.materno}'),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.004),
                        child: Row(
                          children: [
                            SizedBox(
                              width: ((size.width / 1.2) / 2) - 12,
                              child: Text(
                                  'Edad: ${calculateAge(informacionData.fechaNacimiento, DateTime.now())} años'),
                            ),
                            SizedBox(
                              width: ((size.width / 1.2) / 2) - 12,
                              child: Text(
                                  'Sexo: ${informacionData.sexo == 'm' ? "Masculino" : "Femenino"}'),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: ((size.width / 1.2) / 2) - 12,
                            child: Text('Peso: ${informacionData.peso} Kg'),
                          ),
                          SizedBox(
                            width: ((size.width / 1.2) / 2) - 12,
                            child: Text(
                                'Estatura ${informacionData.estatura} mts'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.03,
              bottom: size.height * 0.025,
            ),
            child: SubTitleModulo(size: size),
          ),
          Expanded(
            child: prediagnosticosProvider.prediagnosticosList.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: size.height * 0.06),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.80,
                          child: const Text(
                            'No hay prediagnósticos registrados',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller:
                        prediagnosticosProvider.prediagnosticosScrollController,
                    itemCount:
                        prediagnosticosProvider.prediagnosticosList.length,
                    itemBuilder: (context, index) {
                      final prediagnostico =
                          prediagnosticosProvider.prediagnosticosList[index];
                      final prediagnosticoNumber = index + 1;
                      return PrediagnosticoBubble(
                        isSeguimiento: false,
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
            'Expediente Médico',
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
