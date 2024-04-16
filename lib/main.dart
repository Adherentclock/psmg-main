import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psmg/config/theme/app_theme.dart';
import 'package:psmg/presentation/providers/informacion_medica_provider.dart';
import 'package:psmg/presentation/providers/prediagnostico_provider.dart';
import 'package:psmg/presentation/providers/prediagnostico_sin_seguimiento_provider.dart';
import 'package:psmg/presentation/providers/user_provider.dart';
import 'package:psmg/presentation/screens/escaner_screen/escaner_screen.dart';
import 'package:psmg/presentation/screens/login_screen/login_screen.dart';
import 'package:psmg/presentation/screens/login_screen/register_user_med_screen.dart';
import 'package:psmg/presentation/screens/main_screen/main_med_screen.dart';
import 'package:psmg/presentation/screens/main_screen/main_screen.dart';
import 'package:psmg/presentation/screens/prediagnostico_screen/prediagnostico_screen.dart';
import 'package:psmg/presentation/screens/prueba_screen.dart';
import 'package:psmg/presentation/views/formulario_inicial_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PrediagnosticoProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => InformacionMedicaProvider()),
        ChangeNotifierProvider(
            create: (_) => PrediagnosticosinSeguimientoProvider()),
      ],
      child: MaterialApp(
        title: 'PSMG',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          //Prueba
          "/prueba": (BuildContext context) => const PruebaScreen(),

          //USUARIO:  login - registro - formulario inicial
          "/": (BuildContext context) => const LoginScreen(),
          "/register-user": (BuildContext context) =>
              const RegisterUserMedScreen(),
          "/form-inicial": (BuildContext context) =>
              const FormularioInicialView(),

          //USUARIO: Modulos
          "/main": (BuildContext context) => const MainScreen(),
          "/prediagnostico": (BuildContext context) =>
              const PrediagnosticoScreen(),
          "/escaner": (BuildContext context) => const EscanerScreen(),

          //Medico
          "/mainMed": (BuildContext context) => const MainMedScreen(),
        },
        theme: AppTheme(selectedColor: 0).theme(),
      ),
    );
  }
}
