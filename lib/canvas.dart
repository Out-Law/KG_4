import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';

class CanvasWidget extends StatefulWidget {
  Offset CircleOne = const Offset(0, 0);
  Offset CircleTwo = const Offset(0, 0);

  Offset RectangleOne = const Offset(0, 0);
  Offset RectangleTwo = const Offset(0, 0);
  Offset RectangleThree = const Offset(0, 0);

  CanvasWidget({Key? key,
    required this.CircleOne,
    required this.CircleTwo,
    required this.RectangleOne,
    required this.RectangleTwo,
    required this.RectangleThree
  }) : super(key: key);

  @override
  _CanvasWidgetState createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true,
      painter: CanvasPainter(
          widget.CircleOne,
          widget.CircleTwo,
          widget.RectangleOne,
          widget.RectangleTwo,
          widget.RectangleThree
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  List<Offset> points = <Offset>[];
  List<Offset> pointsCircle = <Offset>[];
  Offset CircleOne = const Offset(0, 0);
  Offset CircleTwo = const Offset(0, 0);

  Offset RectangleOne = const Offset(0, 0);
  Offset RectangleTwo = const Offset(0, 0);
  Offset RectangleThree = const Offset(0, 0);
  CanvasPainter(
      this.CircleOne,
      this.CircleTwo,
      this.RectangleOne,
      this.RectangleTwo,
      this.RectangleThree
      );

  @override
  void paint(Canvas canvas, Size size) {
    drawRectangle(canvas, const Size(250, 300), RectangleOne.dx, RectangleOne.dy);
    drawRectangle(canvas, const Size(50, 50), RectangleTwo.dx, RectangleTwo.dy);
    drawRectangle(canvas, const Size(400, 75), RectangleThree.dx, RectangleThree.dy);
    drawCircle(canvas, Offset(CircleOne.dx+25, CircleOne.dy+25), 25);
    drawCircle(canvas, Offset(CircleTwo.dx+100, CircleTwo.dy+100), 100);
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => false;

  void drawRectangle(Canvas canvas, Size size, double dx, double dy) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final width = size.width;
    final height = size.height;

    for(double i = dx; i < dx + width; i++){
      points.add(Offset(i, dy));
      points.add(Offset(i, dy+height));
    }
    for(double i = dy; i < dy + height; i++){
      points.add(Offset(dx, i));
      points.add(Offset(dx+width, i));
    }

    canvas.drawPoints(PointMode.points, points, paint);
  }


  void drawCircle(Canvas canvas, Offset center, double radius){
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    int x = 0;
    int y = radius.toInt();
    int delta = 1 - 2 * radius.toInt();
    int error = 0;

    while(y >= 0)
    {
      pointsCircle.add(Offset(center.dx + x, center.dy + y));
      pointsCircle.add(Offset(center.dx + x, center.dy - y));
      pointsCircle.add(Offset(center.dx - x, center.dy + y));
      pointsCircle.add(Offset(center.dx - x, center.dy - y));

      error = 2 * (delta + y) - 1;
      if(delta < 0 && error <= 0)
      {
        ++x;
        delta += 2 * x + 1;
        continue;
      }

      error = 2 * (delta - x) - 1;
      if(delta > 0 && error > 0)
      {
        --y;
        delta += 1 - 2 * y;
        continue;
      }

      ++x;
      delta += 2 * (x - y);
      --y;
    }

    canvas.drawPoints(PointMode.points, pointsCircle, paint);
  }


}
