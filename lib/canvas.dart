import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';

class CanvasWidget extends StatefulWidget {

  const CanvasWidget({Key? key}) : super(key: key);

  @override
  _CanvasWidgetState createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true,
      painter: CanvasPainter(),
    );
  }
}

class CanvasPainter extends CustomPainter {

  CanvasPainter();

  @override
  void paint(Canvas canvas, Size size) {
    draw(canvas, size);
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => false;

  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    //drawGrid(canvas, size);

    //canvas.drawCircle(const Offset(150.0, 150.0), 15.0, paint);

    List<Offset> points = <Offset>[const Offset(150.0, 150.0), const Offset(250.0, 250.0)];

    for(double i = 1; i < 50; i++){
      points.add(Offset(150.0+i, 150.0+i));
    }

    canvas.drawPoints(PointMode.points, points, paint);
  }

  void drawRectangle(Canvas canvas, Size size, ) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final width = size.width;
    final height = size.height;

   /* for(double i = widget.topLeft.dx; i < widget.topLeft.dx + widget.width; i++){
      widget.points?.add(Offset(i, widget.topLeft.dy));
      widget.points?.add(Offset(i, widget.topLeft.dy+widget.height));
    }
    for(double i = widget.topLeft.dy; i < widget.topLeft.dy + widget.height; i++){
      widget.points?.add(Offset(widget.topLeft.dx, i));
      widget.points?.add(Offset(widget.topLeft.dx+widget.width, i));
    }*/
  }

}
