import 'package:flutter/material.dart';

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
  void initState() {
    super.initState();
    controller.addListener(onChanged);
  }

  void onChanged() {
    final currentSize = controller.size;
    if (currentSize <= 0.05) collapse();
  }

  void collapse() => animateSheet(getSheet.snapSizes!.first);

  void anchor() => animateSheet(getSheet.snapSizes!.last);

  void expand() => animateSheet(getSheet.maxChildSize);

  void hide() => animateSheet(getSheet.minChildSize);

  void animateSheet(double size) {
    controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  DraggableScrollableSheet get getSheet =>
      (sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colores = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (builder, constraints) {
      return DraggableScrollableSheet(
        key: sheet,
        initialChildSize: 0.5,
        maxChildSize: 1, //hacer 1 para cubrir toda la pantalla.
        minChildSize: 0,
        expand: true,
        snap: true,

        snapSizes: [
          180 / constraints.maxHeight,
          0.5,
        ],
        builder: (BuildContext context, ScrollController scrollContoller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: colores.primary,
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 1),
                )
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22), topRight: Radius.circular(22)),
            ),
            child: CustomScrollView(
              controller: scrollContoller,
              slivers: [
                topButtonIndicator(colores),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    child: widget.child,
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }

  SliverToBoxAdapter topButtonIndicator(ColorScheme colors) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Wrap(
              children: <Widget>[
                Container(
                  width: 100,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.primary, // Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
