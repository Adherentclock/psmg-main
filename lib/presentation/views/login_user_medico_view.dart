import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:psmg/config/helpers/login_register_helpers/login_med.dart';
import 'package:psmg/config/helpers/login_register_helpers/login_user.dart';
import 'package:psmg/presentation/providers/informacion_medica_provider.dart';
import 'package:psmg/presentation/widgets/Styles/style.dart';

// ignore: must_be_immutable
class LoginUserMedicoView extends StatefulWidget {
  bool isUser;
  LoginUserMedicoView({super.key, required this.isUser});

  @override
  State<LoginUserMedicoView> createState() => _LoginUserMedicoViewState();
}

class _LoginUserMedicoViewState extends State<LoginUserMedicoView> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final LoginUser loginUser = LoginUser();
  final LoginMed loginMed = LoginMed();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    //_checkToken();
  }

  Future<void> _checkToken() async {
    String? token = await _storage.read(key: 'token');
    String? isUser = await _storage.read(key: 'user');
    String? infData = await _storage.read(key: 'infData');
    // print("ya");
    // print(token);
    // print(infData);
    if (token != null) {
      if (isUser == 'si') {
        if (infData == 'si') {
          navigateToMain();
        } else {
          navigateToForm();
        }
      } else {
        navigateToMainMed();
      }
    }
  }

  void navigateToMain() {
    Navigator.of(context).pushNamed("/main");
  }

  void navigateToMainMed() {
    Navigator.of(context).pushNamed("/mainMed");
  }

  void navigateToForm() {
    Navigator.of(context).pushNamed("/form-inicial");
  }

  int aux = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    void showToast(String message) {
      Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: colors.primary.withOpacity(1),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    final informacionMedicaProvider =
        context.watch<InformacionMedicaProvider>();
    if (aux == 0) {
      _checkToken();
    }
    aux = 1;
    final Style estilos = Style(context: context);
    final size = MediaQuery.of(context).size;
    final VoidCallback funcBtnIS = widget.isUser
        ? () {
            Future<String> respuesta = loginUser.loginUser(
                _correoController.text, _contrasenaController.text);
            respuesta.then(
              (value) async {
                showToast(value); // Imprime el mensaje de éxito o error
                if (value == "Sesión Iniciada") {
                  await informacionMedicaProvider.actInfMedicaData();
                  final informationData =
                      informacionMedicaProvider.informacionMedicaData;
                  if (informationData.id == 0) {
                    await _storage.write(key: 'infData', value: 'no');
                    navigateToForm();
                  } else {
                    await _storage.write(key: 'infData', value: 'si');
                    navigateToMain();
                  }
                }
              },
            );
          }
        : () {
            Future<String> respuesta = loginMed.loginMed(
                _correoController.text, _contrasenaController.text);
            respuesta.then(
              (value) async {
                showToast(value); // Imprime el mensaje de éxito o error
                if (value == "Sesión Iniciada") {
                  navigateToMainMed();
                }
              },
            );
          };
    //final VoidCallback FuncBtnReg = isUser
    final VoidCallback funcBtnReg = widget.isUser
        ? () => Navigator.of(context).pushNamed("/register-user")
        : () => Navigator.of(context).pushNamed("/register-user");
    final String avatarimage = widget.isUser
        ? 'assets/images/user_login.png'
        : 'assets/images/doctor_login.png';
    final String soyMed = widget.isUser ? "Soy Médico" : "NO soy Médico";
    final List<Color> bgColor = widget.isUser
        ? [
            const Color(0xFF4274BF),
            const Color(0xFF6DB7FA),
            const Color(0xFFB5D7FF),
            const Color(0x9BA5FFF9),
          ]
        : [
            const Color.fromARGB(255, 44, 189, 119),
            const Color(0x1422D981),
            //Colors.black.withOpacity(0.13)
          ];
    final Color avatarBg = widget.isUser ? Colors.white : Colors.transparent;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(children: [
          estilos.gradiantBackground(size, bgColor),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SpacerBox(size: size.width / 5),
                PrincipalAvatar(
                    avatarBg: avatarBg, size: size, avatarimage: avatarimage),
                SpacerBox(size: size.height / 25),
                Title(size: size),
                SpacerBox(size: size.height / 25),
                Container(
                  width: size.width * 0.85,
                  height: size.height * 0.33,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colors.secondary
                            .withOpacity(0.5), //Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(
                            10, 10), // cambia la posición de la sombra
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SpacerBox(size: size.height / 60),
                      InputsData(
                          size: size,
                          textLabel: 'Correo Electronico',
                          controllerData: _correoController,
                          ocultar: false),
                      SpacerBox(size: size.height / 60),
                      InputsData(
                          size: size,
                          textLabel: 'Contraseña',
                          controllerData: _contrasenaController,
                          ocultar: true),
                      SpacerBox(size: size.height / 30),
                      SizedBox(
                        width: size.width * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            funcBtnIS();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Iniciar Sesión"),
                              /*if (_loading)
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),*/
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SpacerBox(size: size.height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes una cuenta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                        height: 0,
                      ),
                    ),
                    GestureDetector(
                      onTap: funcBtnReg,
                      child: const Text(
                        '   Regístrate',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF151A8E),
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isUser = !widget.isUser;
                    });
                  },
                  child: Text(
                    soyMed,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF188E16),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
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
  });

  final Size size;
  final TextEditingController controllerData;
  final String textLabel;
  final bool ocultar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.7,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextField(
        obscureText: ocultar,
        controller: controllerData,
        cursorOpacityAnimates: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: textLabel,
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'PSMG',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: size.height * 0.06,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PrincipalAvatar extends StatelessWidget {
  const PrincipalAvatar({
    super.key,
    required this.avatarBg,
    required this.size,
    required this.avatarimage,
  });

  final Color avatarBg;
  final Size size;
  final String avatarimage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: avatarBg,
      radius: size.width * 0.21,
      child: Image.asset(avatarimage),
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
