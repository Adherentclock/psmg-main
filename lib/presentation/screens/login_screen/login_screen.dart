import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psmg/presentation/views/login_user_medico_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isUser = true;
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didpop) async {
          SystemNavigator.pop();
        },
        child: Scaffold(
          body: LoginUserMedicoView(isUser: isUser),
        ),
      ),
    );
  }
}
