import 'package:flutter/material.dart';

class PruebaScreen extends StatelessWidget {
  const PruebaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DraggableSheet(
      child: SizedBox(
        height: 100,
      ),
    );
  }
}

class DraggableSheet extends StatefulWidget {
  final Widget child;
  const DraggableSheet({super.key, required this.child});

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builder, constraints) {
      return DraggableScrollableSheet(
        key: sheet,
        initialChildSize: 0.5,
        maxChildSize: 0.95, //hacer 1 para cubrir toda la pantalla.
        minChildSize: 0,
        expand: true,
        snap: true,
        snapSizes: [
          60 / constraints.maxHeight,
          0.5,
        ],
        builder: (BuildContext context, ScrollController scrollContoller) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow,
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: Offset(0, 1),
                )
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22), topRight: Radius.circular(22)),
            ),
            child: CustomScrollView(
              controller: scrollContoller,
              slivers: [
                SliverToBoxAdapter(
                  child: widget.child,
                )
              ],
            ),
          );
        },
      );
    });
  }
}
