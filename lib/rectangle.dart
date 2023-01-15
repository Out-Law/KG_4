import 'package:flutter/material.dart';
import 'package:kg/canvas.dart';
import 'package:kg/shape.dart';


class Rectangle extends StatefulWidget  with Shape {
  final Offset topLeft;
  final int width;
  final int height;

  Rectangle({
    Key? key,
    required this.topLeft,
    required this.width,
    required this.height
  }) : super(key: key);

  @override
  State<Rectangle> createState() => _RectangleState();
}

class _RectangleState extends State<Rectangle> {


  @override
  void initState() {
    super.initState();
    for(double i = widget.topLeft.dx; i < widget.topLeft.dx + widget.width; i++){
      widget.points?.add(Offset(i, widget.topLeft.dy));
      widget.points?.add(Offset(i, widget.topLeft.dy+widget.height));
    }
    for(double i = widget.topLeft.dy; i < widget.topLeft.dy + widget.height; i++){
      widget.points?.add(Offset(widget.topLeft.dx, i));
      widget.points?.add(Offset(widget.topLeft.dx+widget.width, i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
