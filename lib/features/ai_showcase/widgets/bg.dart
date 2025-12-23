import 'package:flutter/material.dart';

class Bg extends StatelessWidget {
  const Bg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B0F1A), Color(0xFF141225), Color(0xFF0B1A2A)],
        ),
      ),
    );
  }
}
