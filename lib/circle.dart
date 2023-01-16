import 'dart:ui';
import 'dart:math';

class Arc {
  double? angle;
  double? length;

  Arc({this.angle, this.length});

  Arc.angle(
      Offset startAng, Offset endAng, Offset start, int radius, bool mode) {
    Offset center = Offset(start.dx + radius, start.dx + radius);

    double begin = findAngle(startAng, center);
    double end = findAngle(endAng, center);

    if (end < begin) {
      double temp = begin;
      begin = end;
      end = temp;
    }

    length = end - begin;
    angle = begin;

    if (length! > 180) {
      length = 360 - end + begin;
      angle = end;
    }

    if (mode && length! < 180) {
      length = 360 - end + begin;
      angle = end;

      if (length! < 180) {
        length = end - begin;
        angle = begin;
      }
    }
  }

  double findAngle(Offset ang, Offset center) {
    double angle = atan2(ang.dx - center.dx, ang.dy - center.dy) * (180 / pi);

    if (angle == 0) {
      angle = 90;
    } else if (angle == 90) {
      angle = 0;
    } else if (angle == 180) {
      angle = 270;
    } else if (angle == -90) {
      angle = 180;
    } else {
      //1 квадрант
      if (angle > 0 && angle > 90) {
        angle = 450 - angle;
      }
      //2, 3, 4 квадрант
      else {
        angle = 90 - angle;
      }
    }

    return angle;
  }
}

class Circle {
  int? radius;
  Offset? center;
  final List<Arc> arcs = <Arc>[];

  Circle({this.radius, this.center});

  // void Clear()
  // {
  //     _clip.Clear();
  // }

  //изменить радиус
  void setRadius(int radius) {
    radius = radius;
  }

  //изменить координату
  void setOffset(Offset Offset) {
    center = Offset;
  }

  Offset setCenter() {
    return Offset(center!.dx + radius!, center!.dx + radius!);
  }

  //получить радиус
  int getRadius() {
    return radius!;
  }

  //получить координату
  Offset getOffset() {
    return center!;
  }

  void addArc(Offset start, Offset end, bool mode) {
    arcs.add(Arc.angle(start, end, center!, radius!, mode));
  }

  void addArcAllCircle() {
    arcs.add(Arc(angle: 0, length: 360));
  }

  void sort() {
    if (arcs.isNotEmpty) {
      //объединить повторения
      arcs.sort(
          (Arc x, Arc y) => (x.angle!.round() == y.angle!.round()) ? 0 : 1);

      double tempAng = arcs[0].angle!;
      double tempLen = arcs[0].length!;

      List<Arc> result = <Arc>[];

      result.forEach(((arc) {
        if (tempAng < arc.angle!) {
          if (tempAng + tempLen < arc.angle!) {
            result.add(Arc(angle: tempAng, length: tempLen));
          } else {
            tempLen = arc.angle! + arc.length! - tempAng;
          }
        }
      }));
    }
  }

  List<Arc> getArcs() {
    return arcs;
  }

  List<Arc> getVisible() {
    List<Arc> result = <Arc>[];

    double startOfDrawingArc;
    double lengthOfDrawingArc;

    double a, b;

    if (arcs.isNotEmpty) {
      for (int i = 1; i < arcs.length; i++) {
        startOfDrawingArc = arcs[i - 1].angle! + arcs[i - 1].length! + 0.1;
        lengthOfDrawingArc = arcs[i].angle! - 0.1 - startOfDrawingArc;

        if (lengthOfDrawingArc < 0) {
          a = startOfDrawingArc + lengthOfDrawingArc;
          b = -lengthOfDrawingArc;

          result.add(Arc(angle: a, length: b));
        } else {
          result.add(Arc(angle: startOfDrawingArc, length: lengthOfDrawingArc));
        }
      }

      double startOfLastDrawingArc =
          arcs[arcs.length - 1].angle! + arcs[arcs.length - 1].length! + 0.1;
      double lengthOfLastDrawingArc = 360 - startOfLastDrawingArc;

      result.add(
          Arc(angle: startOfLastDrawingArc, length: lengthOfLastDrawingArc));

      if (arcs[0].angle! != 0.0) {
        startOfLastDrawingArc = 0.0;
        lengthOfLastDrawingArc = arcs[0].angle! - 0.1;

        result.add(
            Arc(angle: startOfLastDrawingArc, length: lengthOfLastDrawingArc));
      }
    } else {
      result.add(Arc(angle: 0, length: 360));
    }
    return result;
  }
}
