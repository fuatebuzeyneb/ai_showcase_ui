import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlipCard extends StatelessWidget {
  final bool enabled;
  final AnimationController flip;
  final Widget front;
  final Widget back;

  const FlipCard({
    super.key,
    required this.enabled,
    required this.flip,
    required this.front,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return front;

    return AnimatedBuilder(
      animation: flip,
      builder: (_, __) {
        final v = flip.value; // 0..1
        final angle = v * math.pi;
        final isBack = v > 0.5;

        final transform =
            Matrix4.identity()
              ..setEntry(3, 2, 0.0018)
              ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child:
              isBack
                  ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: back,
                  )
                  : front,
        );
      },
    );
  }
}
