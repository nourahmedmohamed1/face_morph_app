// الملف: lib/painters/face_painter.dart
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  final List<Face> faces; // الوجوه اللي الذكاء اكتشفها
  final Size imageSize;   // حجم الصورة الأصلية
  final InputImageRotation rotation; // اتجاه الموبايل

  FacePainter(this.faces, this.imageSize, this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    // إعدادات القلم (لونه أحمر وسمكه 3)
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.red;

    for (final face in faces) {
      // معادلات تحويل الأبعاد عشان المربع يترسم صح مهما كان حجم الشاشة
      final left = _translateX(face.boundingBox.left, size, imageSize, rotation);
      final top = _translateY(face.boundingBox.top, size, imageSize, rotation);
      final right = _translateX(face.boundingBox.right, size, imageSize, rotation);
      final bottom = _translateY(face.boundingBox.bottom, size, imageSize, rotation);

      // رسم المستطيل
      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint,
      );
    }
  }

  // دوال مساعدة لحساب الأبعاد (Math Magic 📐)
  double _translateX(double x, Size size, Size imageSize, InputImageRotation rotation) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return x * size.width / imageSize.height;
      default:
        return x * size.width / imageSize.width;
    }
  }

  double _translateY(double y, Size size, Size imageSize, InputImageRotation rotation) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y * size.height / imageSize.width;
      default:
        return y * size.height / imageSize.height;
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}