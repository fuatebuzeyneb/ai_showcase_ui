import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/card_data.dart';
import 'glass.dart';

class ChosenCard extends StatelessWidget {
  final CardData data;
  final AnimationController dissolve;
  final AnimationController successFade;

  const ChosenCard({
    super.key,
    required this.data,
    required this.dissolve,
    required this.successFade,
  });

  @override
  Widget build(BuildContext context) {
    return Glass(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(image: data.image, fit: BoxFit.cover),

                    // dissolve colored cover
                    AnimatedBuilder(
                      animation: dissolve,
                      builder: (_, __) {
                        final o = (1.0 - dissolve.value).clamp(0.0, 1.0);
                        return Opacity(
                          opacity: o,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: data.gradient,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // success fades out after dissolve
                    AnimatedBuilder(
                      animation: successFade,
                      builder: (_, __) {
                        final opacity = (1.0 - successFade.value).clamp(
                          0.0,
                          1.0,
                        );
                        return Opacity(
                          opacity: opacity,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.22),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.20),
                                ),
                              ),
                              child: ClipOval(
                                child: Lottie.asset(
                                  'assets/lottie/check_success.json',
                                  fit: BoxFit.contain,
                                  repeat: false,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Selected",
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Opacity(
              opacity: 0.85,
              child: Text(
                "${data.title} • ${data.subtitle}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
