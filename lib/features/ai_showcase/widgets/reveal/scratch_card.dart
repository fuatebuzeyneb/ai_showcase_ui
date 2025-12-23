import 'package:flutter/material.dart';

class ScratchCard extends StatelessWidget {
  final ValueNotifier<List<Offset>> points;
  final Color coverColor;

  const ScratchCard({
    super.key,
    required this.points,
    required this.coverColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Offset>>(
      valueListenable: points,
      builder: (_, pts, __) {
        return CustomPaint(
          painter: ScratchPainter(points: pts, coverColor: coverColor),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class ScratchPainter extends CustomPainter {
  final List<Offset> points;
  final Color coverColor;

  ScratchPainter({required this.points, required this.coverColor});

  @override
  void paint(Canvas canvas, Size size) {
    final coverPaint = Paint()..color = coverColor;
    canvas.drawRect(Offset.zero & size, coverPaint);

    final clearPaint =
        Paint()
          ..blendMode = BlendMode.clear
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 34;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], clearPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ScratchPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.coverColor != coverColor;
  }
}
