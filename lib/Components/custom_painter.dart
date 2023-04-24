import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint brush = Paint();

    brush.color = Colors.amber.shade100;
    brush.style = PaintingStyle.fill;

    Path path = Path();

    path.quadraticBezierTo(0, size.height, size.width, size.height);

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, brush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
