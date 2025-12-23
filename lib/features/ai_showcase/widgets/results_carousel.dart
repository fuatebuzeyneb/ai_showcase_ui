import 'package:ai_showcase_ui/features/ai_showcase/stage.dart';
import 'package:flutter/material.dart';
import '../models/card_data.dart';

import 'flip_card.dart';
import 'showcase_card.dart';
import 'chosen_card.dart';

class ResultsCarousel extends StatelessWidget {
  final PageController page;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final Future<void> Function(int) onTapCard;
  final List<CardData> cards;

  final int? chosenIndex;
  final AnimationController flip;
  final Stage stage;

  final AnimationController dissolve;
  final AnimationController successFade;

  const ResultsCarousel({
    super.key,
    required this.page,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onTapCard,
    required this.cards,
    required this.chosenIndex,
    required this.flip,
    required this.stage,
    required this.dissolve,
    required this.successFade,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 285,
          child: PageView.builder(
            controller: page,
            itemCount: cards.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final isChosen = chosenIndex == index;
              final flipEnabled = (stage == Stage.chosen) && isChosen;

              return GestureDetector(
                onTap: (stage == Stage.results) ? () => onTapCard(index) : null,
                child: FlipCard(
                  enabled: flipEnabled,
                  flip: flip,
                  front: ShowcaseCard(data: cards[index], index: index),
                  back: ChosenCard(
                    data: cards[index],
                    dissolve: dissolve,
                    successFade: successFade,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Opacity(
          opacity: 0.75,
          child: Text(
            (stage == Stage.results)
                ? "Swipe → then tap a card to select"
                : "Selected ✅",
            style: const TextStyle(color: Colors.white, fontSize: 12.8),
          ),
        ),
      ],
    );
  }
}
