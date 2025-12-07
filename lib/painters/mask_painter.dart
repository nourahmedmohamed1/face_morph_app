import 'package:flutter/material.dart';

class MaskPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 🚧 TODO: Person 4 will implement Matrix transformations & Drawing here

    // Example: Drawing a dummy rectangle to indicate face position
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: 200,
          height: 250
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}