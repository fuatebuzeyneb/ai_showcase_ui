import 'dart:async';

import 'package:ai_showcase_ui/features/ai_showcase/widgets/action_chip.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'data/showcase_cards.dart';
import 'models/card_data.dart';
import 'stage.dart';

import 'widgets/bg.dart';
import 'widgets/glass.dart';
import 'widgets/icon_box.dart';
import 'widgets/pill.dart';
import 'widgets/results_carousel.dart';
import 'widgets/reveal/reveal_overlay.dart';

class AiShowcasePage extends StatefulWidget {
  const AiShowcasePage({super.key});

  @override
  State<AiShowcasePage> createState() => _AiShowcasePageState();
}

class _AiShowcasePageState extends State<AiShowcasePage>
    with TickerProviderStateMixin {
  Stage stage = Stage.idle;

  Timer? _timer;

  // Animations
  late final AnimationController _modalIn = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  late final AnimationController _dissolve = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final AnimationController _successFade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );

  late final AnimationController _mainOut = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  late final AnimationController _flip = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  late final AnimationController _particlesCtrl = AnimationController(
    vsync: this,
  );

  int _particlesLoopsLeft = 0;

  // Data
  final List<CardData> cards = showcaseCards;

  // Selection
  late final PageController _page = PageController(viewportFraction: 0.84);
  int currentIndex = 0;
  int? chosenIndex;
  CardData? selectedCard;

  @override
  void dispose() {
    _timer?.cancel();
    _page.dispose();

    _modalIn.dispose();
    _dissolve.dispose();
    _successFade.dispose();
    _mainOut.dispose();
    _flip.dispose();
    _particlesCtrl.dispose();

    super.dispose();
  }

  void _startGenerate() {
    _timer?.cancel();
    _flip.reset();
    _dissolve.reset();
    _successFade.reset();

    setState(() {
      stage = Stage.generating;
      chosenIndex = null;
      selectedCard = null;
      currentIndex = 0;
    });

    // fake generate 10s
    _timer = Timer(const Duration(seconds: 10), () {
      if (!mounted) return;

      setState(() => stage = Stage.results);

      // particles
      _particlesLoopsLeft = 1;
      _particlesCtrl
        ..stop()
        ..reset()
        ..forward();

      // modal in
      _modalIn
        ..stop()
        ..reset()
        ..forward();

      _mainOut
        ..stop()
        ..reset();
    });
  }

  Future<void> _pickCard(int index) async {
    if (stage != Stage.results) return;

    setState(() {
      chosenIndex = index;
      selectedCard = cards[index];
      stage = Stage.chosen;
    });

    // flip
    _flip
      ..stop()
      ..reset();
    await _flip.forward();
    if (!mounted) return;

    // keep success for a moment (successFade: 0 => full visible)
    _successFade
      ..stop()
      ..reset();
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // dissolve gradient to reveal image
    _dissolve
      ..stop()
      ..reset();
    await _dissolve.forward();
    if (!mounted) return;

    // fade out success
    await _successFade.forward();
    if (!mounted) return;

    // keep image alone 1s
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    // go to reveal
    _mainOut
      ..stop()
      ..reset()
      ..forward();

    _modalIn
      ..stop()
      ..reset();

    setState(() => stage = Stage.revealing);
  }

  void _resetAll() {
    _timer?.cancel();

    _flip.reset();
    _modalIn.reset();
    _mainOut.reset();
    _successFade.reset();
    _dissolve.reset();

    setState(() {
      stage = Stage.idle;
      chosenIndex = null;
      selectedCard = null;
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Bg(),

          // Particles (optional)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: SizedBox(
                  width: 900,
                  height: 900,
                  child: Opacity(
                    opacity: (_particlesLoopsLeft > 0) ? 0.45 : 0.0,
                    child: Lottie.asset(
                      'assets/lottie/particles.json',
                      controller: _particlesCtrl,
                      repeat: false,
                      onLoaded: (comp) {
                        _particlesCtrl.duration = comp.duration;
                        _particlesCtrl.addStatusListener((status) {
                          if (status == AnimationStatus.completed) {
                            if (_particlesLoopsLeft > 1) {
                              _particlesLoopsLeft--;
                              _particlesCtrl
                                ..reset()
                                ..forward();
                            } else {
                              _particlesLoopsLeft = 0;
                              _particlesCtrl.stop();
                              if (context.mounted) {
                                // ignore: invalid_use_of_protected_member
                                (context as Element).markNeedsBuild();
                              }
                            }
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Reveal overlay (depends on selection)
          if (stage == Stage.revealing && selectedCard != null)
            Positioned.fill(
              child: RevealOverlay(
                imageProvider: selectedCard!.image,
                title: selectedCard!.revealTitle,
                location: selectedCard!.location,
                details: selectedCard!.details,
                onClose: _resetAll,
              ),
            ),

          // Top pills
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Pill(
                    icon: Icons.smart_toy_rounded,
                    text: "AI Showcase",
                    onTap: _resetAll,
                  ),
                  const Spacer(),
                  if (stage == Stage.results || stage == Stage.chosen)
                    Pill(
                      icon: Icons.refresh_rounded,
                      text: "Generate again",
                      onTap: _startGenerate,
                    ),
                ],
              ),
            ),
          ),

          // Main content (fade out when revealing)
          IgnorePointer(
            ignoring: stage == Stage.revealing,
            child: AnimatedBuilder(
              animation: _mainOut,
              builder: (_, child) {
                final t = (stage == Stage.revealing) ? _mainOut.value : 0.0;
                final opacity = 1.0 - t;
                final scale = 1.0 - (t * 0.04);

                return Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: Lottie.asset(
                            'assets/lottie/ai_orb.json',
                            fit: BoxFit.contain,
                            repeat: true,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Glass(
                          child: Padding(
                            padding: EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconBox(icon: Icons.auto_awesome_rounded),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Hi! I’m your AI assistant.\nTap Generate to create options, then choose one.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      height: 1.35,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: const [
                            ActionChipWidget(
                              label: "Summarize",
                              icon: Icons.subject_rounded,
                            ),
                            ActionChipWidget(
                              label: "Analyze",
                              icon: Icons.insights_rounded,
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                (stage == Stage.generating)
                                    ? null
                                    : _startGenerate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.14),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.18),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.bolt_rounded),
                                const SizedBox(width: 10),
                                Text(
                                  stage == Stage.generating
                                      ? "Generating…"
                                      : "Generate Photo",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child:
                              (stage == Stage.generating)
                                  ? Padding(
                                    key: const ValueKey("gen"),
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Glass(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 64,
                                              height: 38,
                                              child: Lottie.asset(
                                                'assets/lottie/generating.json',
                                                fit: BoxFit.contain,
                                                repeat: true,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Opacity(
                                                opacity: 0.85,
                                                child: Text(
                                                  "Generating 3 options… (10s)",
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  : const SizedBox(key: ValueKey("nog")),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Results modal
          if (stage == Stage.results || stage == Stage.chosen)
            Positioned.fill(
              child: Stack(
                children: [
                  Container(color: Colors.black.withOpacity(0.55)),
                  Center(
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _modalIn,
                        curve: Curves.easeOut,
                      ),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _modalIn,
                            curve: Curves.easeOutBack,
                          ),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 650),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Glass(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 14,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 6),
                                        const Text(
                                          "Choose one",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: _resetAll,
                                          icon: const Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ResultsCarousel(
                                      cards: cards,
                                      page: _page,
                                      currentIndex: currentIndex,
                                      onPageChanged:
                                          (i) =>
                                              setState(() => currentIndex = i),
                                      onTapCard: _pickCard,
                                      chosenIndex: chosenIndex,
                                      flip: _flip,
                                      stage: stage,
                                      dissolve: _dissolve,
                                      successFade: _successFade,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
