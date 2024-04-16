import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:psmg/config/helpers/post_configuracion.dart';
import 'package:psmg/presentation/providers/informacion_medica_provider.dart';
import 'package:psmg/presentation/providers/prediagnostico_provider.dart';
import 'package:psmg/presentation/providers/user_provider.dart';
import 'package:psmg/presentation/widgets/Styles/style.dart';

class ConfiguracionView extends StatefulWidget {
  const ConfiguracionView({super.key});

  @override
  State<ConfiguracionView> createState() => _ConfiguracionViewState();
}

class _ConfiguracionViewState extends State<ConfiguracionView> {
  int aux = 0;
  final _storage = const FlutterSecureStorage();

  TextEditingController nombreController = TextEditingController();
  TextEditingController paternoController = TextEditingController();
  TextEditingController maternoController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController estaturaController = TextEditingController();
  bool diabetes = false;
  bool obesidad = false;
  bool hipertension = false;
  bool readOnly = true;
  String dropDownValue = 'm';
  String btnFecha = 'Selec. Fecha';
  String sexo = '';
  DateTime fechaNac = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Style estilos = Style(context: context);

    final userProvider = context.watch<UserProvider>();
    final userData = userProvider.userData;
    final informacionMedicaProvider =
        context.watch<InformacionMedicaProvider>();
    final informacionData = informacionMedicaProvider.informacionMedicaData;
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final prediagnosticosProvider = context.watch<PrediagnosticoProvider>();

    TextEditingController nombreControllerE =
        TextEditingController(text: userData.nombre);
    TextEditingController paternoControllerE =
        TextEditingController(text: userData.paterno);
    TextEditingController maternoControllerE =
        TextEditingController(text: userData.materno);
    TextEditingController pesoControllerE =
        TextEditingController(text: informacionData.peso.toString());
    TextEditingController estaturaControllerE =
        TextEditingController(text: informacionData.estatura.toString());
    bool diabetesE = informacionData.diabetes == 1 ? true : false;
    bool obesidadE = informacionData.obesidad == 1 ? true : false;
    bool hipertensionE = informacionData.hipertension == 1 ? true : false;
    String dropDownValueE = informacionData.sexo;
    String sexoE = informacionData.sexo == 'm' ? 'Masculino' : 'Femenino';
    DateTime fechaNacE = informacionData.fechaNacimiento;

    final ScrollController scrollController = ScrollController();

    void obtnPred() async {
      await prediagnosticosProvider.verPrediagnostico();
      diabetes = informacionData.diabetes == 1 ? true : false;
      obesidad = informacionData.obesidad == 1 ? true : false;
      hipertension = informacionData.hipertension == 1 ? true : false;
      nombreController = TextEditingController(text: userData.nombre);
      paternoController = TextEditingController(text: userData.paterno);
      maternoController = TextEditingController(text: userData.materno);
      dropDownValue = informacionData.sexo;
      sexo = informacionData.sexo == 'm' ? 'Masculino' : 'Femenino';
      pesoController =
          TextEditingController(text: informacionData.peso.toString());
      estaturaController =
          TextEditingController(text: informacionData.estatura.toString());
      fechaNac = informacionData.fechaNacimiento;
    }

    if (aux == 0) {
      obtnPred();
    }
    setState(() {
      aux = 1;
    });

    void navigateToLogin() {
      Navigator.of(context).pushNamed("/");
    }

    void navigateToMain() {
      Navigator.of(context).pushNamed("/main");
    }

    Future<void> deleteTokenInformacion() async {
      await _storage.delete(key: 'token');
      await _storage.delete(key: 'infData');
      if (await _storage.read(key: 'token') == null &&
          await _storage.read(key: 'infData') == null) {
        navigateToLogin();
      }
    }

    void showToast(String message) {
      Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: colors.primary,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    void enviar() async {
      Map<String, dynamic> datos = {
        "nombre": nombreController.text,
        "paterno": paternoController.text,
        "materno": maternoController.text,
        "sexo": dropDownValue,
        "fecha_nacimiento": fechaNac.toIso8601String(),
        "peso": pesoController.text,
        "estatura": estaturaController.text,
        "diabetes": diabetes,
        "obesidad": obesidad,
        "hipertension": hipertension,
      };
      String respuesta = await PostConfiguracion().registerConfiguracion(datos);

      if (respuesta == "Guardado") {
        showToast('Información Actualizada');
        setState(() {
          readOnly = true;
        });
        navigateToMain();
      } else {
        showToast('Error al registrar');
        Navigator.pop(context);
      }
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacerBox(size: size.height / 90),
              TitleModulo(size: size, colores: colors),
              SpacerBox(size: size.height / 55),
              SpacerBox(size: size.height / 40),
              SubTitleModulo(
                size: size,
                texto: 'Información Personal',
              ),
              InputText(
                size: size,
                label: 'Nombre (s)*',
                hint: 'Ingrese su nombre (s)',
                type: TextInputType.text,
                ocultar: false,
                controller: readOnly ? nombreControllerE : nombreController,
                readOnly: readOnly,
                colors: colors,
                ancho: 0.85,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio.';
                  } else if (value.length > 45) {
                    return 'El nombre no puede tener más de 45 caracteres.';
                  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
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
                controller: readOnly ? paternoControllerE : paternoController,
                readOnly: readOnly,
                colors: colors,
                ancho: 0.85,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio.';
                  } else if (value.length > 45) {
                    return 'El nombre no puede tener más de 45 caracteres.';
                  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
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
                readOnly: readOnly,
                controller: readOnly ? maternoControllerE : maternoController,
                colors: colors,
                ancho: 0.85,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio.';
                  } else if (value.length > 45) {
                    return 'El nombre no puede tener más de 45 caracteres.';
                  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Ingrese solo letras.';
                  }
                  return null;
                },
              ),
              estilos.spacerBox(size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelInput(size: size, texto: 'Fecha de Nacimiento:'),
                    Padding(
                      padding: EdgeInsets.only(right: size.width * 0.034),
                      child: ElevatedButton(
                        onPressed: readOnly
                            ? null
                            : () async {
                                final DateTime? dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: readOnly ? fechaNacE : fechaNac,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2030),
                                );
                                if (dateTime != null) {
                                  setState(() {
                                    fechaNac = dateTime;
                                    btnFecha =
                                        "${fechaNac.day}/${fechaNac.month}/${fechaNac.year}";
                                  });
                                } else {
                                  showToast(
                                      'Por favor seleccione una fecha de nacimiento.');
                                }
                              },
                        child: Text(readOnly
                            ? "${fechaNacE.day}/${fechaNacE.month}/${fechaNacE.year}"
                            : "${fechaNac.day}/${fechaNac.month}/${fechaNac.year}"),
                      ),
                    ),
                  ],
                ),
              ),
              SpacerBox(size: size.height / 60),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelInput(size: size, texto: 'Sexo:'),
                    Padding(
                      padding: EdgeInsets.only(right: size.width * 0.034),
                      child: DropdownButton<String>(
                        value: readOnly ? dropDownValueE : dropDownValue,
                        icon: const Icon(Icons.menu),
                        style: TextStyle(color: colors.primary),
                        underline: Container(
                          height: 2,
                          color: colors.secondary,
                        ),
                        onChanged: readOnly
                            ? null
                            : (String? nuevoValor) {
                                setState(() {
                                  dropDownValue = nuevoValor!;
                                  sexo = dropDownValue;
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
              ),
              SpacerBox(size: size.height / 60),
              FilaInput(
                size: size,
                controllerData: readOnly ? pesoControllerE : pesoController,
                label: 'Peso',
                typeText: TextInputType.number,
                labelInput: '',
                readOnly: readOnly,
                colors: colors,
                ancho: 0.18,
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
                controllerData:
                    readOnly ? estaturaControllerE : estaturaController,
                label: 'Estatura:',
                typeText: TextInputType.number,
                labelInput: '',
                readOnly: readOnly,
                colors: colors,
                ancho: 0.18,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio.';
                  } else if (value.length > 5) {
                    return 'La estatura no puede tener más de 5 caracteres.';
                  } else if (!RegExp(r'^\d{1}(\.\d{1,2})?$').hasMatch(value)) {
                    return 'Ingrese una estatura válida (1 entero y 2 decimales).';
                  } else if (double.parse(value) > 2.99) {
                    return 'La estatura no puede ser mayor de 3 metros.';
                  }
                  return null;
                },
              ),
              SpacerBox(size: size.height / 200),
              CheckBoxPregunta(
                titulo: '¿Has sido diagnosticado con diabetes?',
                selectedValue: readOnly ? diabetesE : diabetes,
                onChange: (value) {
                  setState(() {
                    diabetes = value!;
                  });
                },
              ),
              SpacerBox(size: size.height / 500),
              CheckBoxPregunta(
                titulo: '¿Has sido diagnosticado con obesidad?',
                selectedValue: readOnly ? obesidadE : obesidad,
                onChange: (value) {
                  setState(() {
                    obesidad = value!;
                  });
                },
              ),
              SpacerBox(size: size.height / 500),
              CheckBoxPregunta(
                titulo: '¿Has sido diagnosticado con hipertensión?',
                selectedValue: readOnly ? hipertensionE : hipertension,
                onChange: (value) {
                  setState(() {
                    hipertension = value!;
                  });
                },
              ),
              SpacerBox(size: size.height / 50),
              Center(
                child: FloatingActionButton.extended(
                  backgroundColor: !readOnly ? Colors.grey : Colors.white,
                  onPressed: !readOnly
                      ? null
                      : () {
                          setState(() {
                            readOnly = false;
                          });
                        },
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    "Editar",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.10,
                    vertical: size.height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: readOnly
                          ? const Color.fromARGB(255, 74, 30, 30)
                          : Colors.red,
                      onPressed: readOnly
                          ? null
                          : () {
                              setState(() {
                                readOnly = true;
                              });
                            },
                      icon: Icon(Icons.cancel,
                          color: readOnly ? Colors.white : Colors.black),
                      label: Text(
                        "Cancelar",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: readOnly ? Colors.white : Colors.black),
                      ),
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: readOnly
                          ? colors.primary.withOpacity(0.5)
                          : colors.primary,
                      onPressed: readOnly
                          ? null
                          : () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('¿Estás seguro?'),
                                    content: const Text(
                                      '¿Estás seguro de guardar las modificaciones?',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        child: const Text('Guardar'),
                                        onPressed: () {
                                          enviar();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                      icon: Icon(Icons.save,
                          color: readOnly ? Colors.white : Colors.black),
                      label: Text(
                        "Guardar",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: readOnly ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              SpacerBox(size: size.height / 50),
              SubTitleModulo(
                size: size,
                texto: 'Información de Privacidad',
              ),
              SpacerBox(size: size.height / 30),
              Center(child: btnCerrarSesion(context, deleteTokenInformacion)),
              SpacerBox(size: size.height / 30),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton btnCerrarSesion(
      BuildContext context, Future<void> Function() deleteTokenInformacion) {
    return FloatingActionButton.extended(
      backgroundColor: const Color.fromARGB(255, 47, 47, 47),
      label: const Text(
        'Cerrar Sesión',
        style:
            TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
      ),
      icon: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Estás seguro?'),
              content: const Text(
                'Estas seguro de cerrar sesión?',
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Salir'),
                  onPressed: () {
                    deleteTokenInformacion();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class SubTitleModulo extends StatelessWidget {
  const SubTitleModulo({
    super.key,
    required this.size,
    required this.texto,
  });

  final Size size;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
          ),
          child: Text(
            texto,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.height * 0.021,
              color: Colors.black,
            ),
          ),
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
          width: size.width * 0.82,
          child: Text(
            'Configuración',
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

class Btn extends StatelessWidget {
  const Btn({
    super.key,
    required this.size,
    required this.colores,
    required this.color,
    required this.label,
    required this.icon,
    required this.function,
  });

  final Size size;
  final ColorScheme colores;
  final Color color;
  final String label;
  final Icon icon;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: color,
      onPressed: function,
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
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
    required this.readOnly,
    required this.colors,
    required this.ancho,
    required this.validator,
  });

  final Size size;
  final String label;
  final String hint;
  final TextInputType type;
  final bool ocultar;
  final bool readOnly;
  final ColorScheme colors;
  final double ancho;
  final FormFieldValidator<String> validator;

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: size.height * 0.027,
          left: size.width * 0.05,
          right: size.width * 0.05),
      child: Container(
        width: size.width * ancho,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: TextFormField(
          readOnly: readOnly,
          obscureText: ocultar,
          controller: controller,
          cursorOpacityAnimates: true,
          keyboardType: TextInputType.text,
          style: TextStyle(
            fontSize: size.height * 0.016,
          ),
          decoration: InputDecoration(
            labelText: label,
            contentPadding: const EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: colors.primary,
                width: 1.0,
              ),
            ),
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
      title: Text(
        titulo,
        style: const TextStyle(fontSize: 14),
      ),
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
      child: Text(texto),
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
    required this.readOnly,
    required this.colors,
    required this.ancho,
    required this.validator,
  });

  final Size size;
  final TextEditingController controllerData;
  final String label;
  final TextInputType typeText;
  final String labelInput;
  final ColorScheme colors;
  final bool readOnly;
  final double ancho;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width * 0.5,
            child: Text(label),
          ),
          InputText(
            ancho: ancho,
            size: size,
            label: "",
            hint: "",
            type: TextInputType.number,
            ocultar: false,
            controller: controllerData,
            readOnly: readOnly,
            colors: colors,
            validator: (String? value) {},
          )
        ],
      ),
    );
  }
}
