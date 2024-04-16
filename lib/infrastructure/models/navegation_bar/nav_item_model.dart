import 'rive_model.dart';

class NavItemModel {
  final String title;
  final RiveModel rive;

  NavItemModel({required this.title, required this.rive});
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(
    title: "Inicio",
    rive: RiveModel(
      src: "assets/animated_icon.riv",
      artboard: "HOME",
      stateMachineName: "HOME_interactivity",
    ),
  ),
  NavItemModel(
    title: "Chat",
    rive: RiveModel(
      src: "assets/animated_icon.riv",
      artboard: "CHAT",
      stateMachineName: "CHAT_Interactivity",
    ),
  ),
  NavItemModel(
    title: "Seguimiento",
    rive: RiveModel(
      src: "assets/animated_icon.riv",
      artboard: "BELL",
      stateMachineName: "BELL_Interactivity",
    ),
  ),
  NavItemModel(
    title: "Expediente",
    rive: RiveModel(
      src: "assets/animated_icon.riv",
      artboard: "TIMER",
      stateMachineName: "TIMER_Interactivity",
    ),
  ),
  NavItemModel(
    title: "Configuración",
    rive: RiveModel(
      src: "assets/animated_icon.riv",
      artboard: "SETTINGS",
      stateMachineName: "SETTINGS_Interactivity",
    ),
  ),
];
List<NavItemModel> bottomNavMedItems = [
  NavItemModel(
    title: "Chat",
    rive: RiveModel(
      src: "assets/animated_icon.riv",
      artboard: "CHAT",
      stateMachineName: "CHAT_Interactivity",
    ),
  ),
  NavItemModel(
    title: "Configuración",
    rive: RiveModel(
      src: "assets/animated_icon.riv",
      artboard: "SETTINGS",
      stateMachineName: "SETTINGS_Interactivity",
    ),
  ),
];
