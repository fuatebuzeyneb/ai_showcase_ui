import 'package:flutter/material.dart';

class TypewriterInfo extends StatelessWidget {
  final AnimationController controller;
  final String title;
  final String location;
  final String details;

  const TypewriterInfo({
    super.key,
    required this.controller,
    required this.title,
    required this.location,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final all = "$title\n$location\n\n$details";

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final n = (all.length * controller.value).floor().clamp(0, all.length);
        final txt = all.substring(0, n);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Text(
            txt,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
