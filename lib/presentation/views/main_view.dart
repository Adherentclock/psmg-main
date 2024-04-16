import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psmg/infrastructure/models/scroll_list/scroll_list.dart';
import 'package:psmg/presentation/providers/informacion_medica_provider.dart';
import 'package:psmg/presentation/providers/user_provider.dart';
import 'package:psmg/presentation/widgets/Styles/style.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:url_launcher/url_launcher.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<ScrollList> servicesList = [
    ScrollList('assets/images/IA_11.jpg',
        'Prediagnostico de Enfermedades'), //assets/images/imgvr2.PNG'
    ScrollList('assets/images/ESCAN_12.jpg',
        'Escaneo de Médicamentos'), //assets/images/imgvr2.PNG
  ];
  final List<String> descriptionsList = [
    "En esta seccion de la aplicación se encarga de hacer el prediagnostico de enfermedades haciendo uso de sintomas y un modelo de IA. ",
    "En esta seccion se abre una segunda aplicación que ayuda al usuario a escanear cajas de medicamentos y mostrar información importante. "
  ];
  String texto1 = '';
  String texto2 = '';
  int index = 0;
  int aux = 0;

  @override
  void initState() {
    super.initState();
    texto1 = servicesList[index].title;
    texto2 = descriptionsList[index];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final informacionMedicaProvider =
        context.watch<InformacionMedicaProvider>();
    void actinf() async {
      await userProvider.actUserData();
      await informacionMedicaProvider.actInfMedicaData();
    }

    if (aux == 0) {
      actinf();
      aux += 1;
    }

    final size = MediaQuery.of(context).size;
    final ColorScheme colores = Theme.of(context).colorScheme;
    final userData = userProvider.userData;
    final infMedData = informacionMedicaProvider.informacionMedicaData;
    final Style estilos = Style(context: context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          estilos.spacerBox(size.height / 40),
          Center(
            child: estilos.textoEstilo(
                'Pantalla Principal', size.height * 0.04, colores.primary),
          ),
          estilos.spacerBox(size.height / 70),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.036),
            child: estilos.textoEstilo(
                '${infMedData.sexo == 'm' ? "Bienvenido" : "Bienvenida"} ${userData.nombre}',
                size.height * 0.03,
                colores.secondary),
          ),
          estilos.spacerBox(size.height / 30),
          Container(
            margin: const EdgeInsets.all(10),
            height: size.height * 0.44,
            child: SizedBox(
              child: ScrollSnapList(
                itemBuilder: _buildListItem,
                itemCount: servicesList.length,
                itemSize: 200,
                onItemFocus: (index) {
                  setState(() {
                    texto1 = servicesList[index].title;
                    texto2 = descriptionsList[index];
                  });
                },
                dynamicItemOpacity: 0.5,
                dynamicItemSize: true,
                focusOnItemTap: true,
                curve: Curves.fastOutSlowIn,
              ),
            ),
          ),
          estilos.spacerBox(size.height / 60),
          Center(
              child: estilos.textoEstilo(
                  texto1, size.height * 0.024, colores.primary)),
          estilos.spacerBox(size.height / 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.036),
            child: estilos.textoEstilo(
                'Descripción:', size.height * 0.022, colores.secondary),
          ),
          estilos.spacerBox(size.height / 60),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.036),
            child: Text(
              texto2,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    ScrollList scroll = servicesList[index];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: colores.primary
                .withOpacity(0.3), //Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(10, 10), // cambia la posición de la sombra
          ),
        ],
      ),
      width: 200,
      child: GestureDetector(
        onTap: () {
          index == 0
              ? Navigator.of(context).pushNamed("/prediagnostico")
              : abrirAppEscaner(); //abrir la app de escaneo
        },
        child: Card(
          //shadowColor: colores.primary,
          elevation: 4,

          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Image.asset(
              scroll.imgPath,
              fit: BoxFit.fitHeight,
              width: 250,
            ),
          ),
        ),
      ),
    );
  }

  void abrirAppEscaner() async {
    const url = 'unitydl://mylink';
    if (await canLaunchUrl(Uri.parse(url))) {
      // Se quita canLaunch(url) por Deprecated
      await launchUrl(Uri.parse(url));
    } else {
      throw 'La aplicación no esta instalada';
    }
  }
}
