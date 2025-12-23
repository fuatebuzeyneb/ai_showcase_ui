import 'package:flutter/material.dart';

class CardData {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final ImageProvider image;

  final String revealTitle;
  final String location;
  final String details;

  const CardData({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.image,
    required this.revealTitle,
    required this.location,
    required this.details,
  });
}
