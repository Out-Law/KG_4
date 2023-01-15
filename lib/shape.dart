import 'dart:ui';

abstract class Shape {
  List<Offset>? points = <Offset>[];
  void move(Offset offset){
    points?.forEach((element) {
      element = Offset(element.dx+offset.dx, element.dy+offset.dy);
    });
  }
}
