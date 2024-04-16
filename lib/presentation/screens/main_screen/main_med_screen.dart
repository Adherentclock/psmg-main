import 'package:flutter/material.dart';
import 'package:psmg/infrastructure/models/navegation_bar/nav_item_model.dart';
import 'package:psmg/presentation/views/chat_med_view.dart';
import 'package:psmg/presentation/views/configuracion_med_view.dart';
import 'package:psmg/presentation/widgets/shared/back_button_handle.dart';
import 'package:rive/rive.dart';

class MainMedScreen extends StatefulWidget {
  const MainMedScreen({super.key});

  @override
  State<MainMedScreen> createState() => _MainMedScreenState();
}

class _MainMedScreenState extends State<MainMedScreen> {
  List<SMIBool?> riveIconInputs =
      List.filled(5, null); // Inicializar con 5 SMIBool null

  List<StateMachineController?> controllers = [];

  List<String> pages = ["Mensajes", "Configuraciones"];
  final views = [
    const ChatMedView(),
    const ConfiguracionMedView(),
  ];

  int selectedNavIndex = 0;

  /*void clearExpedienteCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('prediagnosticos'); // Remove cache key
  }*/

  void animateTheIcon(int index) {
    riveIconInputs[index]?.change(true); // Usar operador null-safe
    Future.delayed(
      const Duration(seconds: 1),
      () {
        riveIconInputs[index]?.change(false);
      },
    );
  }

  void riveOnInit(Artboard artboard, int index,
      {required String stateMachineName}) {
    final controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);

    if (controller != null) {
      artboard.addController(controller);
      controllers.add(controller);

      final activeInput = controller.findInput<bool>('active');

      if (activeInput != null) {
        riveIconInputs[index] =
            activeInput as SMIBool; // Asignar al índice correcto
      } else {
        // Manejar el caso de la entrada 'active' no encontrada
      }
    } else {
      // Manejar el caso del controlador nulo
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  int aux1 = 0;

  @override
  Widget build(BuildContext context) {
    final BackButtonHandle backButtonHandle =
        BackButtonHandle(context: context);
    final colors = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        backButtonHandle.showBackDialog();
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(245, 247, 243, 1),
        body: views[selectedNavIndex],
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              // height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.7),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.4),
                    offset: const Offset(0, 20),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  bottomNavMedItems.length,
                  (index) {
                    final riveIcon = bottomNavMedItems[index].rive;
                    return GestureDetector(
                      //implementar aqui
                      onTap: () {
                        animateTheIcon(index);
                        setState(() {
                          selectedNavIndex = index;
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBar(
                              isActive: selectedNavIndex == index,
                              colores: colors),
                          SizedBox(
                            height: 36,
                            width: 36,
                            child: Opacity(
                              opacity: selectedNavIndex == index ? 1 : 0.5,
                              child: RiveAnimation.asset(
                                riveIcon.src,
                                artboard: riveIcon.artboard,
                                onInit: (artboard) {
                                  riveOnInit(artboard, index,
                                      stateMachineName:
                                          riveIcon.stateMachineName);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
    required this.colores,
  });

  final bool isActive;
  final ColorScheme colores;

  @override
  Widget build(BuildContext context) {
    var colorBarra = colores.secondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 25 : 0,
      decoration: BoxDecoration(
        color: colorBarra,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
