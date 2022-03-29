import 'dart:math';
import 'package:flutter/material.dart';

class BoundaryWidget extends StatelessWidget {
  final double diameter;
  final double sweepAngle;
  final Color color;
  final double thickness;
  BoundaryWidget({
    this.diameter = 200,
    required this.sweepAngle,
    required this.color,
    required this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(
        sweepAngle,
        color,
        thickness,
      ),
      size: Size(diameter, diameter),
    );
  }
}

//Helper for Boundary Widget
class MyPainter extends CustomPainter {
  MyPainter(
    this.sweepAngle,
    this.color,
    this.thickness,
  );
  final double sweepAngle;
  final Color color;
  final double thickness;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..color = color;
    final Paint paint2 = Paint()
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..color = const Color(0xffE5E5E5);

    double degToRad(double deg) => deg * (pi / 180.0);

    final path1 = Path()
      ..arcTo(
          Rect.fromCenter(
            center: Offset(size.height / 2, size.width / 2),
            height: size.height,
            width: size.width,
          ),
          degToRad(0),
          degToRad(sweepAngle),
          false);
    final path2 = Path()
      ..arcTo(
          Rect.fromCenter(
            center: Offset(size.height / 2, size.width / 2),
            height: size.height,
            width: size.width,
          ),
          degToRad(sweepAngle),
          degToRad(360 - sweepAngle),
          false);

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
