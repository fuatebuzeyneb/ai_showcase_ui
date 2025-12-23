import 'package:flutter/material.dart';
import '../models/card_data.dart';

const showcaseCards = <CardData>[
  CardData(
    title: "Option A",
    subtitle: "Winter • Calm",
    gradient: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
    image: NetworkImage(
      "https://images.unsplash.com/photo-1765734482969-13490010637a?q=80&w=985&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ),
    revealTitle: "Snowy Harbor",
    location: "Northern Coast",
    details:
        "Style: Travel • Mood: Calm & Cold • Color: Blue/Gray tones\n"
        "Focus: Small boat, snowy dock, misty mountains\n"
        "Prompt tags: winter, harbor, fishing boat, fjord, soft light, cinematic",
  ),
  CardData(
    title: "Option B",
    subtitle: "Street • Neon",
    gradient: [Color(0xFFF97316), Color(0xFFEF4444)],
    image: NetworkImage(
      "https://images.unsplash.com/photo-1764418658910-c00b609c089e?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ),
    revealTitle: "Neon Crossing",
    location: "Tokyo, Japan",
    details:
        "Style: Street • Mood: Energetic • Color: Neon highlights\n"
        "Focus: Busy crosswalk, city lights, motion blur\n"
        "Prompt tags: tokyo, shibuya, night, neon, street photography, crowd, bokeh",
  ),
  CardData(
    title: "Option C",
    subtitle: "Nature • Falls",
    gradient: [Color(0xFF22C55E), Color(0xFF3B82F6)],
    image: NetworkImage(
      "https://images.unsplash.com/photo-1765871321198-30fffc41e605?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ),
    revealTitle: "Granite Falls",
    location: "Mountain Forest",
    details:
        "Style: Nature • Mood: Fresh & Powerful • Color: Green/Stone\n"
        "Focus: Tall waterfall, pine forest, granite cliffs\n"
        "Prompt tags: waterfall, forest, aerial view, national park, dramatic, ultra detail",
  ),
];
