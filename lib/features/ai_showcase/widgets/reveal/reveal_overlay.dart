import 'dart:ui';
import 'package:flutter/material.dart';
import 'scratch_card.dart';
import 'typewriter_info.dart';

class RevealOverlay extends StatefulWidget {
  final ImageProvider imageProvider;
  final String title;
  final String location;
  final String details;
  final VoidCallback onClose;

  const RevealOverlay({
    super.key,
    required this.imageProvider,
    required this.title,
    required this.location,
    required this.details,
    required this.onClose,
  });

  @override
  State<RevealOverlay> createState() => _RevealOverlayState();
}

class _RevealOverlayState extends State<RevealOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _in = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  )..forward();

  late final AnimationController _type = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..forward();

  final ValueNotifier<List<Offset>> _points = ValueNotifier<List<Offset>>([]);

  @override
  void dispose() {
    _in.dispose();
    _type.dispose();
    _points.dispose();
    super.dispose();
  }

  void _clearScratch() => _points.value = [];

  @override
  Widget build(BuildContext context) {
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _in, curve: Curves.easeOutCubic));
    final fade = CurvedAnimation(parent: _in, curve: Curves.easeOut);

    return Material(
      color: Colors.black.withOpacity(0.78),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withOpacity(0.72)),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 680),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.white.withOpacity(0.14)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 32,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  "Reveal Result",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: widget.onClose,
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: AspectRatio(
                              aspectRatio: 16 / 10,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image(
                                    image: widget.imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  RepaintBoundary(
                                    child: ScratchCard(
                                      points: _points,
                                      coverColor: Colors.black.withOpacity(
                                        0.55,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Builder(
                                      builder: (ctx) {
                                        return GestureDetector(
                                          onPanStart: (d) {
                                            final rb =
                                                ctx.findRenderObject()
                                                    as RenderBox;
                                            final p = rb.globalToLocal(
                                              d.globalPosition,
                                            );
                                            _points.value = [
                                              ..._points.value,
                                              p,
                                            ];
                                          },
                                          onPanUpdate: (d) {
                                            final rb =
                                                ctx.findRenderObject()
                                                    as RenderBox;
                                            final p = rb.globalToLocal(
                                              d.globalPosition,
                                            );
                                            _points.value = [
                                              ..._points.value,
                                              p,
                                            ];
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.25),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: const Text(
                                          "Scratch to reveal",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: _clearScratch,
                                  child: Text(
                                    "Reset scratch",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: widget.onClose,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(
                                      0.14,
                                    ),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(0.18),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    "Done",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TypewriterInfo(
                            controller: _type,
                            title: widget.title,
                            location: widget.location,
                            details: widget.details,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
