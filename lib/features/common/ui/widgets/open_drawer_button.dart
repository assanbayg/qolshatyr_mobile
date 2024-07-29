// Flutter imports:
import 'package:flutter/material.dart';

class OpenDrawerButton extends StatelessWidget {
  const OpenDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    void openDrawer() {
      Scaffold.of(context).openDrawer();
    }

    return Positioned(
      left: 0,
      top: MediaQuery.of(context).size.height / 2 - 24,
      child: IconButton(
        icon: const Icon(Icons.arrow_forward_rounded),
        onPressed: openDrawer,
      ),
    );
  }
}
