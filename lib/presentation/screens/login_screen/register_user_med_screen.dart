import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psmg/config/helpers/login_register_helpers/register_med.dart';
import 'package:psmg/config/helpers/login_register_helpers/register_user.dart';
import 'package:psmg/presentation/widgets/Styles/style.dart';

class RegisterUserMedScreen extends StatefulWidget {
  const RegisterUserMedScreen({super.key});

  @override
  State<RegisterUserMedScreen> createState() => _RegisterUserMedScreenState();
}

class _RegisterUserMedScreenState extends State<RegisterUserMedScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _paternoController = TextEditingController();
  final TextEditingController _maternoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _ccontrasenaController = TextEditingController();
  final TextEditingController _calleController = TextEditingController();
  final TextEditingController _numExtController = TextEditingController();
  final TextEditingController _coloniaController = TextEditingController();
  final TextEditingController _codPostController = TextEditingController();
  final TextEditingController _numContactoController = TextEditingController();
  final RegisterUser registerUser = RegisterUser();
  final RegisterMed registerMed = RegisterMed();

  String selectedFilePath = '';

  bool _isMed = false;
  @override
  Widget build(BuildContext context) {
    final Style estilos = Style(context: context);
    final List<Color> bgColor = [
      const Color(0xFF4274BF),
      const Color(0xFF6DB7FA),
      const Color(0xFFB5D7FF),
      const Color(0x9BA5FFF9),
    ];
    final size = MediaQuery.of(context).size;
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

    void registarUsuario() {
      Map<String, dynamic> datos = {
        "nombre": _nombreController.text,
        "paterno": _paternoController.text,
        "materno": _maternoController.text,
        "correo": _correoController.text,
        "contrasena": _contrasenaController.text
      };
      Future<String> respuesta = registerUser.registerUser(datos);
      respuesta.then(
        (value) {
          // Imprime el mensaje de éxito o error
          if (value == "Usuario registrado exitosamente") {
            showToast(value);
            Navigator.of(context).pushNamed("/");
          } else {
            showToast("Error al registrar, intente de nuevo");
          }
        },
      );
    }

    void registarMedico() {
      if (selectedFilePath == '') {
        showToast('Seleccione su cedula profesional');
        return;
      }
      Map<String, dynamic> datos = {
        "nombre": _nombreController.text,
        "paterno": _paternoController.text,
        "materno": _maternoController.text,
        "correo": _correoController.text,
        "contrasena": _contrasenaController.text,
        "calle": _calleController.text,
        "numero": _numExtController.text,
        "colonia": _coloniaController.text,
        "codigo_postal": _codPostController.text,
        "num_contacto": _numContactoController.text,
        "celdula": selectedFilePath,
      };
      Future<String> respuesta = registerMed.registerMed(datos);
      respuesta.then(
        (value) {
          // Imprime el mensaje de éxito o error
          if (value == "Usuario registrado exitosamente") {
            showToast(value);
            Navigator.of(context).pushNamed("/");
          } else {
            showToast("Error al registrar, intente de nuevo");
          }
        },
      );
    }

    Future<int> obtenerTamanoArchivo(File file) async {
      final stat = file.statSync();
      return stat.size;
    }

    Future<bool> validarTamanoArchivo(File file) async {
      final tamano = await obtenerTamanoArchivo(file);
      return tamano <= 3000000;
    }

    Future<void> selectPDF() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        if (await validarTamanoArchivo(file)) {
          showToast('Archivo seleccionado');
          setState(() {
            selectedFilePath = result.files.single.path!;
          });
        } else {
          showToast('Error: El archivo supera los 3Mb');
        }
      }
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Stack(
            children: [
              estilos.gradiantBackground(size, bgColor),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    estilos.spacerBox(size.height * 0.034),
                    estilos.textoEstilo(
                        'Crear Cuenta', size.width * 0.11, Colors.white),
                    estilos.spacerBox(size.height * 0.05),
                    Center(
                      child: Container(
                        height: size.height * 0.72,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colors.secondary,
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(10, 10),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              estilos.spacerBox(size.height * 0.02),
                              InputText(
                                size: size,
                                label: 'Nombre (s)*',
                                hint: 'Ingrese su nombre (s)',
                                type: TextInputType.text,
                                ocultar: false,
                                controller: _nombreController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Este campo es obligatorio.';
                                  } else if (value.length > 45) {
                                    return 'El nombre no puede tener más de 45 caracteres.';
                                  } else if (!RegExp(r'^[a-zA-Z]+$')
                                      .hasMatch(value)) {
                                    return 'Ingrese solo letras.';
                                  }
                                  return null;
                                },
                              ),
                              estilos.spacerBox(size.height * 0.01),
                              InputText(
                                size: size,
                                label: 'Apellido Paterno*',
                                hint: 'Ingrese su apellido paterno',
                                type: TextInputType.text,
                                ocultar: false,
                                controller: _paternoController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Este campo es obligatorio.';
                                  } else if (value.length > 45) {
                                    return 'El nombre no puede tener más de 45 caracteres.';
                                  } else if (!RegExp(r'^[a-zA-Z]+$')
                                      .hasMatch(value)) {
                                    return 'Ingrese solo letras.';
                                  }
                                  return null;
                                },
                              ),
                              estilos.spacerBox(size.height * 0.01),
                              InputText(
                                size: size,
                                label: 'Apellido Materno',
                                hint: 'Ingrese su apellido materno',
                                type: TextInputType.text,
                                ocultar: false,
                                controller: _maternoController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Este campo es obligatorio.';
                                  } else if (value.length > 45) {
                                    return 'El nombre no puede tener más de 45 caracteres.';
                                  } else if (!RegExp(r'^[a-zA-Z]+$')
                                      .hasMatch(value)) {
                                    return 'Ingrese solo letras.';
                                  }
                                  return null;
                                },
                              ),
                              estilos.spacerBox(size.height * 0.01),
                              InputText(
                                size: size,
                                label: 'Correo Electronico*',
                                hint: 'Ingrese su correo electronico',
                                type: TextInputType.emailAddress,
                                ocultar: false,
                                controller: _correoController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Este campo es obligatorio.';
                                  } else if (value.length > 45) {
                                    return 'El correo electrónico no puede tener más de 60 caracteres.';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$')
                                      .hasMatch(value)) {
                                    return 'Ingrese un correo electrónico válido.';
                                  }
                                  return null;
                                },
                              ),
                              estilos.spacerBox(size.height * 0.01),
                              InputText(
                                size: size,
                                label: 'Contraseña*',
                                hint: 'Ingrese la contraseña',
                                type: TextInputType.visiblePassword,
                                ocultar: true,
                                controller: _contrasenaController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Este campo es obligatorio.';
                                  } else if (value.length < 8) {
                                    return 'La contraseña debe tener al menos 8 caracteres.';
                                  }
                                  return null;
                                },
                              ),
                              estilos.spacerBox(size.height * 0.01),
                              InputText(
                                size: size,
                                label: 'Confirmación de contraseña*',
                                hint: 'Confirme la contraseña',
                                type: TextInputType.visiblePassword,
                                ocultar: true,
                                controller: _ccontrasenaController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Este campo es obligatorio.';
                                  } else if (value !=
                                      _contrasenaController.text) {
                                    return 'La confirmación de contraseña no coincide.';
                                  }
                                  return null;
                                },
                              ),
                              estilos.spacerBox(size.height * 0.03),
                              estilos.checkBoxPregunta(_isMed, (value) {
                                setState(() {
                                  _isMed = value!;
                                });
                              }, 'Voy a registrarme como médico'),
                              if (_isMed)
                                SizedBox(
                                  width: size.width * 0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      estilos.spacerBox(size.height * 0.02),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.034),
                                        child: estilos.textoDosEstilo(
                                            'Cédula Profesional',
                                            size.width * 0.04,
                                            Colors.black),
                                      ),
                                      estilos.spacerBox(size.height * 0.02),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: selectPDF,
                                          child:
                                              const Text('Seleccionar archivo'),
                                        ),
                                      ),
                                      estilos.spacerBox(size.height * 0.015),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.034,
                                            right: size.width * 0.034),
                                        child: Text(selectedFilePath),
                                      ),
                                      estilos.spacerBox(size.height * 0.015),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.034,
                                            right: size.width * 0.034),
                                        child: estilos.textoDosEstilo(
                                            'Información del consultorio',
                                            size.width * 0.04,
                                            Colors.black),
                                      ),
                                      estilos.spacerBox(size.height * 0.01),
                                      InputText(
                                        size: size,
                                        label: 'Calle',
                                        hint: 'Ingrese la calle',
                                        type: TextInputType.text,
                                        ocultar: false,
                                        controller: _calleController,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Este campo es obligatorio.';
                                          } else if (value.length > 60) {
                                            return 'La calle no puede tener más de 45 caracteres.';
                                          } else if (!RegExp(
                                                  r'^[a-zA-Z0-9\s]+$')
                                              .hasMatch(value)) {
                                            return 'Ingrese solo letras y números.';
                                          }
                                          return null;
                                        },
                                      ),
                                      estilos.spacerBox(size.height * 0.01),
                                      InputText(
                                        size: size,
                                        label: 'Numero Exterior',
                                        hint: 'Ingrese el numero exterior',
                                        type: TextInputType.number,
                                        ocultar: false,
                                        controller: _numExtController,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Este campo es obligatorio.';
                                          } else if (value.length > 5) {
                                            return 'El número exterior no puede tener más de 5 caracteres.';
                                          } else if (!RegExp(r'^[0-9]+$')
                                              .hasMatch(value)) {
                                            return 'Ingrese solo números.';
                                          }
                                          return null;
                                        },
                                      ),
                                      estilos.spacerBox(size.height * 0.01),
                                      InputText(
                                        size: size,
                                        label: 'Colonia',
                                        hint: 'Ingrese la colonia',
                                        type: TextInputType.text,
                                        ocultar: false,
                                        controller: _coloniaController,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Este campo es obligatorio.';
                                          } else if (value.length > 45) {
                                            return 'La colonia no puede tener más de 45 caracteres.';
                                          } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                              .hasMatch(value)) {
                                            return 'Ingrese solo letras.';
                                          }
                                          return null;
                                        },
                                      ),
                                      estilos.spacerBox(size.height * 0.01),
                                      InputText(
                                        size: size,
                                        label: 'Codigo Postal',
                                        hint: 'Ingrese el codigo postal',
                                        type: TextInputType.number,
                                        ocultar: false,
                                        controller: _codPostController,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Este campo es obligatorio.';
                                          } else if (value.length > 5) {
                                            return 'El codigo postal no puede tener más de 5 caracteres.';
                                          } else if (!RegExp(r'^[0-9]+$')
                                              .hasMatch(value)) {
                                            return 'Ingrese solo números.';
                                          }
                                          return null;
                                        },
                                      ),
                                      estilos.spacerBox(size.height * 0.01),
                                      InputText(
                                        size: size,
                                        label: 'Número Contacto',
                                        hint: 'Ingrese el número de contacto',
                                        type: TextInputType.number,
                                        ocultar: false,
                                        controller: _numContactoController,
                                        validator: (String? value) {},
                                      ),
                                    ],
                                  ),
                                ),
                              estilos.spacerBox(size.height / 30),
                              Center(
                                child: SizedBox(
                                  width: size.width * 0.7,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      (!_isMed)
                                          ? registarUsuario()
                                          : registarMedico();
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Enviar"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              estilos.spacerBox(size.height * 0.03),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputText extends StatelessWidget {
  const InputText({
    super.key,
    required this.size,
    required this.label,
    required this.hint,
    required this.type,
    required this.ocultar,
    required this.controller,
    required this.validator,
  });

  final Size size;
  final String label;
  final String hint;
  final TextInputType type;
  final bool ocultar;
  final FormFieldValidator<String> validator;

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * 0.034, right: size.width * 0.034),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: ocultar,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}

class InputTextL extends StatelessWidget {
  const InputTextL({
    super.key,
    required this.size,
    required this.label,
    required this.hint,
    required this.type,
    required this.ocultar,
    required this.controller,
  });

  final Size size;
  final String label;
  final String hint;
  final TextInputType type;
  final bool ocultar;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * 0.034, right: size.width * 0.034),
      child: TextFormField(
        keyboardType: type,
        obscureText: ocultar,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}
