//TODO: Modificar BD alergias

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psmg/config/helpers/post_informacion_medica.dart';

class FormularioInicialView extends StatefulWidget {
  const FormularioInicialView({super.key});

  @override
  State<FormularioInicialView> createState() => _FormularioInicialViewState();
}

class _FormularioInicialViewState extends State<FormularioInicialView> {
  final PostInformacionMedica postInformacionMedica = PostInformacionMedica();
  final List<Color> bgColor = [
    const Color(0xFF4274BF),
    const Color(0xFF6DB7FA),
    const Color(0xFFB5D7FF),
    const Color(0x9BA5FFF9),
  ];
  String btnFecha = 'Selec. Fecha';
  String dropDownValue = 'Seleccione';
  String _sexo = '';
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _estaturaController = TextEditingController();
  final TextEditingController _alergiasContoller = TextEditingController();
  bool _diabetes = false;
  bool _obesidad = false;
  bool _hipertension = false;
  bool _alergia = false;

  final ScrollController _scrollController = ScrollController();
  DateTime _fechaNac = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    void showToast(String message) {
      Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: colors.primary,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Stack(
            children: [
              GradiantBackground(size: size, colores: bgColor),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SpacerBox(size: size.height / 25),
                    Title(size: size),
                    SpacerBox(size: size.height / 25),
                    Container(
                      height: size.height * 0.78,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: colors.secondary,
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(10, 10),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white.withOpacity(1),
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            SpacerBox(size: size.height / 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LabelInput(
                                    size: size, texto: 'Fecha de Nacimiento:'),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: size.width * 0.034),
                                  child: ElevatedButton(
                                    child: Text(btnFecha),
                                    onPressed: () async {
                                      final DateTime? dateTime =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: _fechaNac,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2030),
                                      );
                                      if (dateTime != null) {
                                        setState(() {
                                          _fechaNac = dateTime;
                                          btnFecha =
                                              "${_fechaNac.day}/${_fechaNac.month}/${_fechaNac.year}";
                                        });
                                      } else {
                                        showToast(
                                            'Por favor seleccione una fecha de nacimiento.');
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SpacerBox(size: size.height / 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                LabelInput(size: size, texto: 'Sexo:'),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: size.width * 0.05),
                                  child: DropdownButton<String>(
                                    value: dropDownValue,
                                    icon: const Icon(Icons.menu),
                                    style: TextStyle(color: colors.primary),
                                    underline: Container(
                                      height: 2,
                                      color: colors.secondary,
                                    ),
                                    onChanged: (String? nuevoValor) {
                                      setState(() {
                                        dropDownValue = nuevoValor!;
                                        _sexo = dropDownValue;
                                        // Validar la selección del sexo
                                        if (_sexo != 'm' && _sexo != 'f') {
                                          showToast(
                                              'Por favor seleccione un sexo.');
                                        }
                                      });
                                    },
                                    items: const [
                                      DropdownMenuItem<String>(
                                        value: 'Seleccione',
                                        child: Text('Seleccione'),
                                      ),
                                      DropdownMenuItem<String>(
                                          value: 'm', child: Text('Masculino')),
                                      DropdownMenuItem<String>(
                                          value: 'f', child: Text('Femenino')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SpacerBox(size: size.height / 60),
                            FilaInput(
                              size: size,
                              controllerData: _pesoController,
                              label: 'Peso',
                              typeText: TextInputType.number,
                              labelInput: 'peso',
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Este campo es obligatorio.';
                                } else if (value.length > 6) {
                                  return 'El peso no puede tener más de 5 caracteres.';
                                } else if (!RegExp(r'^\d{1,3}(\.\d{1,2})?$')
                                    .hasMatch(value)) {
                                  return 'Ingrese un peso válido (máximo 3 enteros y 2 decimales).';
                                }
                                return null;
                              },
                            ),
                            SpacerBox(size: size.height / 60),
                            FilaInput(
                              size: size,
                              controllerData: _estaturaController,
                              label: 'Estatura:',
                              typeText: TextInputType.number,
                              labelInput: '',
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Este campo es obligatorio.';
                                } else if (value.length > 5) {
                                  return 'La estatura no puede tener más de 5 caracteres.';
                                } else if (!RegExp(r'^\d{1}(\.\d{1,2})?$')
                                    .hasMatch(value)) {
                                  return 'Ingrese una estatura válida (1 entero y 2 decimales).';
                                } else if (double.parse(value) > 2.99) {
                                  return 'La estatura no puede ser mayor de 3 metros.';
                                }
                                return null;
                              },
                            ),
                            SpacerBox(size: size.height / 30),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.034),
                              child: const SizedBox(
                                child: Text(
                                    'Por favor, marque todas la afirmaciones siguientes que se apliquen a usted.'),
                              ),
                            ),
                            SpacerBox(size: size.height / 30),
                            CheckBoxPregunta(
                              titulo: '¿Has sido diagnosticado con diabetes?',
                              selectedValue: _diabetes,
                              onChange: (value) {
                                setState(() {
                                  _diabetes = value!;
                                });
                              },
                            ),
                            SpacerBox(size: size.height / 30),
                            CheckBoxPregunta(
                              titulo: '¿Has sido diagnosticado con obesidad?',
                              selectedValue: _obesidad,
                              onChange: (value) {
                                setState(() {
                                  _obesidad = value!;
                                });
                              },
                            ),
                            SpacerBox(size: size.height / 30),
                            CheckBoxPregunta(
                              titulo:
                                  '¿Has sido diagnosticado con hipertensión?',
                              selectedValue: _hipertension,
                              onChange: (value) {
                                setState(() {
                                  _hipertension = value!;
                                });
                              },
                            ),
                            SpacerBox(size: size.height / 30),
                            CheckBoxPregunta(
                              titulo: '¿Tiene algun tipo de alergia?',
                              selectedValue: _alergia,
                              onChange: (value) {
                                setState(() {
                                  _alergia = value!;
                                });
                              },
                            ),
                            if (_alergia)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height / 60,
                                  left: size.width * 0.034,
                                  right: size.width * 0.034,
                                ),
                                child: TextFormField(
                                  controller: _alergiasContoller,
                                  maxLines: 5,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'Ingresa las alergias separadas por comas. \n Ejemplo: Paracetamol, polen'),
                                  validator: (String? value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (value.length > 200) {
                                        return 'Las alergias no pueden tener más de 200 caracteres.';
                                      } else if (!RegExp(r'^[a-zA-Z0-9, ]*$')
                                          .hasMatch(value)) {
                                        return 'Ingrese solo letras, números y comas.';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
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
                                  Map<String, dynamic> datos = {
                                    "sexo": _sexo,
                                    "fecha_nacimiento":
                                        _fechaNac.toIso8601String(),
                                    "peso": _pesoController.text,
                                    "estatura": _estaturaController.text,
                                    "diabetes": _diabetes,
                                    "obesidad": _obesidad,
                                    "hipertension": _hipertension
                                  };
                                  Future<String> respuesta =
                                      postInformacionMedica
                                          .registerInformacion(datos);
                                  respuesta.then((value) {
                                    if (value == "SI") {
                                      showToast('Información registrada');
                                      Navigator.of(context).pushNamed("/");
                                    } else {
                                      showToast(
                                          'Error al guardar, intente de nuevo');
                                    }
                                  });
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Enviar"),
                                  ],
                                ),
                              ),
                            ),
                            SpacerBox(size: size.height / 30),
                          ],
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

class CheckBoxPregunta extends StatelessWidget {
  const CheckBoxPregunta({
    super.key,
    required this.titulo,
    required this.selectedValue,
    required this.onChange,
  });

  final bool selectedValue;
  final ValueChanged<bool?>? onChange;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(titulo),
      value: selectedValue,
      onChanged: onChange,
    );
  }
}

class LabelInput extends StatelessWidget {
  const LabelInput({
    super.key,
    required this.size,
    required this.texto,
  });

  final Size size;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.5,
      child: Padding(
        padding: EdgeInsets.only(left: size.width * 0.034),
        child: Text(texto),
      ),
    );
  }
}

class FilaInput extends StatelessWidget {
  const FilaInput({
    super.key,
    required this.size,
    required this.controllerData,
    required this.label,
    required this.typeText,
    required this.labelInput,
    required this.validator,
  });

  final Size size;
  final TextEditingController controllerData;
  final String label;
  final TextInputType typeText;
  final String labelInput;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: Padding(
            padding: EdgeInsets.only(left: size.width * 0.034),
            child: Text(label),
          ),
        ),
        InputsData(
          size: size.width * 0.23,
          textLabel: labelInput,
          typeText: typeText,
          controllerData: controllerData,
          ocultar: false,
          sizePad: size.width * 0.034,
          sizeDisp: size,
        ),
      ],
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
        'Formulario Principal',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: size.height * 0.038,
          color: Colors.white,
        ),
      ),
    );
  }
}

class GradiantBackground extends StatelessWidget {
  const GradiantBackground(
      {super.key, required this.size, required this.colores});

  final Size size;
  final List<Color> colores;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: const Alignment(0.00, -1.00),
              end: const Alignment(0, 1),
              colors: colores)),
    );
  }
}

class InputsData extends StatelessWidget {
  const InputsData({
    super.key,
    required this.size,
    required this.textLabel,
    required this.typeText,
    required this.controllerData,
    required this.ocultar,
    required this.sizePad,
    required this.sizeDisp,
  });

  final double size;
  final TextEditingController controllerData;
  final String textLabel;
  final TextInputType typeText;
  final bool ocultar;
  final double sizePad;
  final Size sizeDisp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: sizePad),
      width: size,
      height: sizeDisp.height * 0.05,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextField(
        obscureText: ocultar,
        controller: controllerData,
        cursorOpacityAnimates: true,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
