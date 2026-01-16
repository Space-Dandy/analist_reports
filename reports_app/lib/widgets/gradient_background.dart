import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.8, -1),
          end: Alignment(0.8, 1),
          colors: [
            Color(0xFFFFFFFF), // #ffffff
            Color(0xFFDDD3ED), // #ddd3ed
          ],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
