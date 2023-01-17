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

  void Clear() {
    arcs.clear();
  }

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

  void clear() {
    arcs.clear();
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
    List<Arc> drawingArcs = <Arc>[];

    List<List<double>> maxArcSegments = <List<double>>[];

    List<List<double>> optimizedMaxArcSegments = <List<double>>[];

    if (arcs.isEmpty) {
      return <Arc>[Arc(angle: 0, length: 360)];
    }

    // Проверяем, пересекаются ли отрезки отрезаемых дуг
    // Если пересекаются, то считается максимальный отрезаемый отрезок дуги
    // И добавляется в массив
    for (int i = 0; i < arcs.length; i++) {
      bool isIncludedInExistedArcSegment = false;
      double curArcStartAngle = arcs[i].angle!;
      double curArcEndAngle = curArcStartAngle + arcs[i].length!;

      for (var arcSegment in maxArcSegments) {
        // 173 (max) <= 185 (cur) && 193 (cur) <= 200 (max)
        // 173 (max) <= 185 (cur) && 200 (cur) <= 200 (max)
        if (arcSegment[0] <= curArcStartAngle &&
            curArcEndAngle <= arcSegment[1]) {
          isIncludedInExistedArcSegment = true;

          double startAngleToadd = arcSegment[0];
          double endAngleToadd = arcSegment[1];

          arcSegment[0] = startAngleToadd;
          arcSegment[1] = endAngleToadd;
          break;
        }
        // 160 (cur) <= 173 (max) && 193 (cur) <= 200 (max)
        else if (curArcStartAngle <= arcSegment[0] &&
            curArcEndAngle <= arcSegment[1] &&
            curArcEndAngle > arcSegment[0]) {
          isIncludedInExistedArcSegment = true;

          double startAngleToadd = curArcStartAngle;
          double endAngleToadd = arcSegment[1];

          arcSegment[0] = startAngleToadd;
          arcSegment[1] = endAngleToadd;
          break;
        }
        // 173 (max) <= 183 (cur) && 200 (max) <= 215 (cur)
        else if (arcSegment[0] <= curArcStartAngle &&
            arcSegment[1] <= curArcEndAngle &&
            arcSegment[1] > curArcStartAngle &&
            curArcEndAngle - 360 < arcSegment[1]) {
          isIncludedInExistedArcSegment = true;

          double startAngleToadd = arcSegment[0];
          double endAngleToadd = curArcEndAngle;

          arcSegment[0] = startAngleToadd;
          arcSegment[1] = endAngleToadd;
          break;
        }
        // 160 (cur) <= 173 (max) && 200 (max) <= 215 (cur)
        else if (curArcStartAngle <= arcSegment[0] &&
            arcSegment[1] <= curArcEndAngle) {
          isIncludedInExistedArcSegment = true;

          double startAngleToadd = curArcStartAngle;
          double endAngleToadd = curArcEndAngle;

          arcSegment[0] = startAngleToadd;
          arcSegment[1] = endAngleToadd;
          break;
        }
      }

      // Если данный отрезок не пересёкся ни с каким из максимальных отрезков,
      // то добавляем его в массив обрезаемых отрезков
      if (!isIncludedInExistedArcSegment) {
        List<double> newArcSegment = <double>[curArcStartAngle, curArcEndAngle];
        maxArcSegments.add(newArcSegment);
      }
    }

    for (int i = 0; i < maxArcSegments.length; i++) {
      for (int j = i; j < maxArcSegments.length; j++) {
        if (maxArcSegments[i][0] > maxArcSegments[j][0]) {
          List<double> tmp = maxArcSegments[i];
          maxArcSegments[i] = maxArcSegments[j];
          maxArcSegments[j] = tmp;
        }
      }
    }

    // Оптимизируем обрезаемые отрезки
    double finalStartAngle = maxArcSegments[0][0];
    double finalEndAngle = maxArcSegments[0][1];
    for (int i = 1; i < maxArcSegments.length; i++) {
      bool somethingChanges = false;

      if (finalStartAngle > maxArcSegments[i][0]) {
        somethingChanges = true;
        finalStartAngle = maxArcSegments[i][0];
      }

      if (finalEndAngle >= maxArcSegments[i][0] &&
          finalEndAngle <= maxArcSegments[i][1]) {
        somethingChanges = true;
        finalEndAngle = maxArcSegments[i][1];
      }

      if ((!somethingChanges && finalStartAngle != finalEndAngle) ||
          i + 1 == maxArcSegments.length) {
        List<double> newOptimizedArcSegment = <double>[
          finalStartAngle,
          finalEndAngle
        ];
        finalStartAngle = finalEndAngle;

        optimizedMaxArcSegments.add(newOptimizedArcSegment);
      }
    }

    optimizedMaxArcSegments.add(<double>[
      maxArcSegments[maxArcSegments.length - 1][0],
      maxArcSegments[maxArcSegments.length - 1][1]
    ]);

    // Проверяем ситуацию, если конец последней обрезаемой дуги будет > 360 градусов
    double lastArcEndAngle =
        optimizedMaxArcSegments[optimizedMaxArcSegments.length - 1][1];
    if (lastArcEndAngle > 360) {
      optimizedMaxArcSegments[optimizedMaxArcSegments.length - 1][1] =
          optimizedMaxArcSegments[optimizedMaxArcSegments.length - 1][1] - 360;
    }

    double startAngle = optimizedMaxArcSegments[0][0];
    double endAngle = optimizedMaxArcSegments[0][1];

    if (optimizedMaxArcSegments.length != 1) {
      for (int i = 1; i < optimizedMaxArcSegments.length; i++) {
        if (optimizedMaxArcSegments[i][0] - endAngle > 0) {
          drawingArcs.add(Arc(
              angle: endAngle,
              length: (optimizedMaxArcSegments[i][0] - endAngle)));
        } else {
          drawingArcs.add(Arc(
              angle: endAngle,
              length: (optimizedMaxArcSegments[i][0] - endAngle + 360)));
        }
        endAngle = optimizedMaxArcSegments[i][1];
      }

      if (startAngle - endAngle > 0) {
        drawingArcs.add(Arc(angle: endAngle, length: (startAngle - endAngle)));
      } else {
        drawingArcs
            .add(Arc(angle: endAngle, length: (startAngle - endAngle + 360)));
      }
    } else {
      if ((360 + startAngle - endAngle) <= 360) {
        drawingArcs
            .add(Arc(angle: endAngle, length: (360 + startAngle - endAngle)));
      } else {
        drawingArcs.add(Arc(angle: endAngle, length: (startAngle - endAngle)));
      }
    }

    return drawingArcs;
  }
}
