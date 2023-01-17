import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'rectangle.dart';
import 'circle.dart';

class CanvasWidget extends StatefulWidget {
  /* Offset CircleOne = const Offset(0, 0);
  Offset CircleTwo = const Offset(0, 0);

  Offset RectangleOne = const Offset(0, 0);
  Offset RectangleTwo = const Offset(0, 0);
  Offset RectangleThree = const Offset(0, 0);*/

  List<Rectangle> rectangles = <Rectangle>[];
  List<Circle> circles = <Circle>[];

  CanvasWidget({Key? key, required this.rectangles, required this.circles})
      : super(key: key);

  @override
  _CanvasWidgetState createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true,
      painter: CanvasPainter(widget.rectangles, widget.circles),
    );
  }
}

class CanvasPainter extends CustomPainter {
  List<Offset> points = <Offset>[];
  List<Offset> pointsCircle = <Offset>[];

  List<Rectangle> rectangles = <Rectangle>[];
  List<Circle> circles = <Circle>[];
  /* Offset CircleOne = const Offset(0, 0);
  Offset CircleTwo = const Offset(0, 0);*/

  int mode = 0;

  /* Offset RectangleOne = const Offset(0, 0);
  Offset RectangleTwo = const Offset(0, 0);
  Offset RectangleThree = const Offset(0, 0);*/

  CanvasPainter(this.rectangles, this.circles);

  @override
  void paint(Canvas canvas, Size size) {
    draw(canvas);
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

    for (double i = dx; i < dx + width; i++) {
      points.add(Offset(i, dy));
      points.add(Offset(i, dy + height));
    }
    for (double i = dy; i < dy + height; i++) {
      points.add(Offset(dx, i));
      points.add(Offset(dx + width, i));
    }

    canvas.drawPoints(PointMode.points, points, paint);
  }

  void drawCircle(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    int x = 0;
    int y = radius.toInt();
    int delta = 1 - 2 * radius.toInt();
    int error = 0;

    while (y >= 0) {
      pointsCircle.add(Offset(center.dx + x, center.dy + y));
      pointsCircle.add(Offset(center.dx + x, center.dy - y));
      pointsCircle.add(Offset(center.dx - x, center.dy + y));
      pointsCircle.add(Offset(center.dx - x, center.dy - y));

      error = 2 * (delta + y) - 1;
      if (delta < 0 && error <= 0) {
        ++x;
        delta += 2 * x + 1;
        continue;
      }

      error = 2 * (delta - x) - 1;
      if (delta > 0 && error > 0) {
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

  int packing(int xl, int xp, int yn, int yv, Offset a) {
    return (a.dx < xl ? 1 : 0) +
        (a.dx > xp ? 2 : 0) +
        (a.dy < yv ? 4 : 0) +
        (a.dy > yn ? 8 : 0);
  }

  void findPart(Offset a, Offset b, int i, Rectangle rec) {
    Offset copya = a;
    Offset copyb = b;

    Offset c;

    int xl = rec.start!.dx.toInt();
    int yv = rec.start!.dy.toInt();
    int xp = rec.start!.dx.toInt() + rec.width!;
    int yn = rec.start!.dy.toInt() + rec.height!;

    int code_a, code_b, code;

    code_a = packing(xl, xp, yn, yv, a);
    code_b = packing(xl, xp, yn, yv, b);

    if (code_a != 0 && code_b != 0) {
      if (((code_a & 8) != 0 && (code_b & 8) != 0 ||
          (code_b & 4) != 0 && (code_a & 4) != 0 ||
          (code_a & 1) != 0 && (code_b & 1) != 0 ||
          (code_a & 2) != 0 && (code_b & 2) != 0)) {
        rectangles[i].addPart(copya, copyb);
        return;
      }

      if (!((code_a & 8) != 0 && (code_b & 4) != 0 ||
          (code_b & 8) != 0 && (code_a & 4) != 0 ||
          (code_a & 1) != 0 && (code_b & 2) != 0 ||
          (code_a & 2) != 0 && (code_b & 1) != 0)) {
        return;
      }
    }

    while ((code_a | code_b) != 0) {
      if (code_a != 0) {
        code = code_a;
        c = a;
      } else {
        code = code_b;
        c = b;
      }

      if ((code & 1) != 0) {
        c = Offset(xl.toDouble(), c.dy);
      } else if ((code & 2) != 0) {
        c = Offset(xp.toDouble(), c.dy);
      } else if ((code & 4) != 0) {
        c = Offset(c.dx, yv.toDouble());
      } else if ((code & 8) != 0) {
        c = Offset(c.dx, yn.toDouble());
      }

      if (code == code_a) {
        code_a = packing(xl, xp, yn, yv, c);
        a = c;
      } else {
        code_b = packing(xl, xp, yn, yv, c);
        b = c;
      }
    }

    if (copya != a) {
      rectangles[i].addPart(copya, a);
    }
    if (copyb != b) {
      rectangles[i].addPart(b, copyb);
    }
  }

  List<Offset> intersectTwoCircles(
      Offset circle1, int radius1, Offset circle2, int radius2) {
    Offset p1 = Offset(-1, -1);
    Offset p2 = Offset(-1, -1);

    int coefX1 = 2 * (-circle1.dx.toInt());
    int x1pow2 = (circle1.dx * circle1.dx).toInt();

    int coefY1 = 2 * (-circle1.dy.toInt());
    int y1pow2 = (circle1.dy * circle1.dy).toInt();

    int circleEquation1 = x1pow2 + y1pow2 - radius1 * radius1;

    int coefX2 = 2 * (-circle2.dx.toInt());
    int x2pow2 = (circle2.dx * circle2.dx).toInt();

    int coefY2 = 2 * (-circle2.dy.toInt());
    int y2pow2 = (circle2.dy * circle2.dy).toInt();

    int circleEquation2 = x2pow2 + y2pow2 - radius2 * radius2;

    int shortedXCoef = coefX1 - coefX2;
    int shortedYCoef = coefY1 - coefY2;
    int shortedAbsoluteTerm = circleEquation1 - circleEquation2;

    if (shortedXCoef != 0) {
      double reducedYCoefRelativeX = -(shortedYCoef.toDouble() / shortedXCoef);
      double reducedAbsoluteTermRelativeX =
          -(shortedAbsoluteTerm.toDouble() / shortedXCoef);

      double aCoefInReplacedDoubledX =
          reducedYCoefRelativeX * reducedYCoefRelativeX;
      double bCoefInReplacedDoubledX =
          2 * reducedYCoefRelativeX * reducedAbsoluteTermRelativeX;
      double cCoefInReplacedDoubledX =
          reducedAbsoluteTermRelativeX * reducedAbsoluteTermRelativeX;

      double aCoefInReplacedX = coefX1 * reducedYCoefRelativeX;
      double bCoefInReplacedX = coefX1 * reducedAbsoluteTermRelativeX;

      double finalACoef = aCoefInReplacedDoubledX + 1;
      double finalBCoef = bCoefInReplacedDoubledX + aCoefInReplacedX + coefY1;
      double finalCCoef =
          cCoefInReplacedDoubledX + bCoefInReplacedX + circleEquation1;

      double discriminant =
          finalBCoef * finalBCoef - 4 * finalACoef * finalCCoef;

      if (discriminant > 0) {
        double y1 = (-finalBCoef + sqrt(discriminant)) / (2 * finalACoef);
        double y2 = (-finalBCoef - sqrt(discriminant)) / (2 * finalACoef);

        double x1 = reducedYCoefRelativeX * y1 + reducedAbsoluteTermRelativeX;
        double x2 = reducedYCoefRelativeX * y2 + reducedAbsoluteTermRelativeX;

        p1 = Offset(x1.round().toDouble(), y1.round().toDouble());
        p2 = Offset(x2.round().toDouble(), y2.round().toDouble());
      }
    } else {
      double reducedXCoefRelativeY = -(shortedXCoef / shortedYCoef);
      double reducedAbsoluteTermRelativeY =
          -(shortedAbsoluteTerm / shortedYCoef);

      double aCoefInReplacedDoubledY =
          reducedXCoefRelativeY * reducedXCoefRelativeY;
      double bCoefInReplacedDoubledY =
          2 * reducedXCoefRelativeY * reducedAbsoluteTermRelativeY;
      double cCoefInReplacedDoubledY =
          reducedAbsoluteTermRelativeY * reducedAbsoluteTermRelativeY;

      double aCoefInReplacedY = coefY1 * reducedXCoefRelativeY;
      double bCoefInReplacedY = coefY1 * reducedAbsoluteTermRelativeY;

      double finalACoef = aCoefInReplacedDoubledY + 1;
      double finalBCoef = bCoefInReplacedDoubledY + aCoefInReplacedY + coefX1;
      double finalCCoef =
          cCoefInReplacedDoubledY + bCoefInReplacedY + circleEquation1;

      double discriminant =
          finalBCoef * finalBCoef - 4 * finalACoef * finalCCoef;

      if (discriminant > 0) {
        double x1 = (-finalBCoef + sqrt(discriminant)) / (2 * finalACoef);
        double x2 = (-finalBCoef - sqrt(discriminant)) / (2 * finalACoef);

        double y1 = reducedXCoefRelativeY * x1 + reducedAbsoluteTermRelativeY;
        double y2 = reducedXCoefRelativeY * x2 + reducedAbsoluteTermRelativeY;

        p1 = Offset(x1.round().toDouble(), y1.round().toDouble());
        p2 = Offset(x2.round().toDouble(), y2.round().toDouble());
      }
    }

    return <Offset>[p1, p2];
  }

  List<Offset> intersectLineAndCircle(Offset circleCenter, int circleRadius,
      Offset linePoint1, Offset linePoint2) {
    Offset p1 = Offset(-1, -1);
    Offset p2 = Offset(-1, -1);

    if (linePoint1.dy == linePoint2.dy) {
      double y = linePoint1.dy;

      int xDoubledCoeff = 1;
      int xSingleCoeff = 2 * (-circleCenter.dx.toInt());
      int xAbsoluteTerm = (circleCenter.dx * circleCenter.dx).toInt();

      int finalAbsoluteTerm = xAbsoluteTerm +
          pow(y - circleCenter.dy, 2).toInt() -
          pow(circleRadius, 2).toInt();

      double discriminant = pow(xSingleCoeff, 2).toDouble() -
          4 * xDoubledCoeff * finalAbsoluteTerm;

      if (discriminant > 0) {
        double x1 = (-xSingleCoeff + sqrt(discriminant)) / (2 * xDoubledCoeff);
        double x2 = (-xSingleCoeff - sqrt(discriminant)) / (2 * xDoubledCoeff);

        p1 = Offset(x1.round().toDouble(), y.round().toDouble());
        p2 = Offset(x2.round().toDouble(), y.round().toDouble());
      }
    } else if (linePoint1.dx == linePoint2.dy) {
      double x = linePoint1.dy;

      int yDoubledCoeff = 1;
      int ySingleCoeff = 2 * (-circleCenter.dy.toInt());
      int yAbsoluteTerm = (circleCenter.dy * circleCenter.dy).toInt();

      int finalAbsoluteTerm = yAbsoluteTerm +
          pow(x - circleCenter.dx, 2).toInt() -
          pow(circleRadius, 2).toInt();

      double discriminant = pow(ySingleCoeff, 2).toDouble() -
          4 * yDoubledCoeff * finalAbsoluteTerm;

      if (discriminant > 0) {
        double y1 = (-ySingleCoeff + sqrt(discriminant)) / (2 * yDoubledCoeff);
        double y2 = (-ySingleCoeff - sqrt(discriminant)) / (2 * yDoubledCoeff);

        p1 = Offset(x.round().toDouble(), y1.round().toDouble());
        p2 = Offset(x.round().toDouble(), y2.round().toDouble());
      }
    }
    List<Offset> res = <Offset>[];
    if (p1 != Offset(-1, -1)) {
      res.add(p1);
    }

    if (p2 != Offset(-1, -1)) {
      res.add(p2);
    }
    return <Offset>[p1, p2];
  }

  int side(Offset a, Offset b, Offset c) {
    Offset m = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);

    return (m.dx > c.dx ? 1 : 0) +
        (m.dx < c.dx ? 2 : 0) +
        (m.dx < c.dy ? 4 : 0) +
        (m.dy > c.dy ? 8 : 0);
  }

  void clear() {
    for (var rect in rectangles) {
      rect.clear();
    }

    for (var circle in circles) {
      circle.clear();
    }
  }

  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawColor(Color(0xFFFFFFFF), BlendMode.color);

    clear();

    for (int i = 0; i < circles.length - 1; i++) {
      for (int j = 1 + i; j < circles.length; j++) {
        Offset circi = circles[i].center!;
        Offset circj = circles[j].center!;
        int radi = circles[i].radius!;
        int radj = circles[j].radius!;

        List<Offset> mac = intersectTwoCircles(circi, radi, circj, radj);

        if (mac[0] != Offset(-1, -1) && mac[1] != Offset(-1, -1)) {
          bool mod = false;
          int x1 = side(mac[0], mac[1], circj);
          int x2 = side(mac[0], mac[1], circi);

          if ((x1 & x2) != 0 && radi < radj) {
            mod = true;
          }

          circles[i].addArc(mac[0], mac[1], mod);
        } else if (radi <= radj &&
            circi.dx >= (circj.dx - radj) &&
            circi.dx <= (circj.dy + radj) &&
            circi.dy >= (circj.dy - radj) &&
            circi.dy <= (circj.dy + radj)) {
          circles[i].addArcAllCircle();
        }
      }
    }

    for (int i = 0; i < circles.length; i++) {
      Circle currentCircle = circles[i];
      Offset circleCenter = currentCircle.center!;
      int circleRadius = currentCircle.radius!;
      for (int j = 0; j < rectangles.length; j++) {
        List<Offset> macX = <Offset>[];
        Rectangle currentRectangle = rectangles[j];
        Offset recPoint = currentRectangle.start!;
        int widht = currentRectangle.width!;
        int height = currentRectangle.height!;

        int macPrev = 0;
        bool top, bottom, left, right;

        Offset a = Offset(recPoint.dx, recPoint.dy);
        Offset b = Offset(recPoint.dx + widht, recPoint.dy);

        List<Offset> intersectcted =
            intersectLineAndCircle(circleCenter, circleRadius, a, b);

        for (var item in intersectcted) {
          macX.add(item);
        }
        top = macPrev != macX.length;
        macPrev = macX.length;

        a = Offset(recPoint.dx, recPoint.dy);
        b = Offset(recPoint.dx, recPoint.dy + height);
        intersectcted =
            intersectLineAndCircle(circleCenter, circleRadius, a, b);

        for (var item in intersectcted) {
          macX.add(item);
        }

        left = macPrev != macX.length;
        macPrev = macX.length;

        a = Offset(recPoint.dx, recPoint.dy + height);
        b = Offset(recPoint.dx + widht, recPoint.dy + height);
        intersectcted =
            intersectLineAndCircle(circleCenter, circleRadius, a, b);

        for (var item in intersectcted) {
          macX.add(item);
        }

        bottom = macPrev != macX.length;
        macPrev = macX.length;

        a = Offset(recPoint.dx + widht, recPoint.dy);
        b = Offset(recPoint.dx + widht, recPoint.dy + height);
        intersectcted =
            intersectLineAndCircle(circleCenter, circleRadius, a, b);

        for (var item in intersectcted) {
          macX.add(item);
        }

        right = macPrev != macX.length;

        if (macX.isEmpty) {
          if (packing(
                  recPoint.dx.toInt(),
                  recPoint.dx.toInt() + widht,
                  recPoint.dy.toInt() + height,
                  recPoint.dy.toInt(),
                  circleCenter) !=
              0) {
            circles[i].addArcAllCircle();
            break;
          }
        } else {
          if (macX.length == 2) {
            bool mod = false;
            int x1 = side(macX[0], macX[1], circleCenter);
            if (right) {
              mod = x1 == 2;
            } else if (left) {
              mod = x1 == 1;
            }
            if (top) {
              mod = x1 == 8;
            }
            if (bottom) {
              mod = x1 == 4;
            }

            currentCircle.addArc(macX[0], macX[1], mod);
          }
        }
      }
    }

    for (int i = 0; i < rectangles.length - 1; i++) {
      for (int j = 1 + i; j < rectangles.length; j++) {
        Offset a = Offset(rectangles[i].start!.dx, rectangles[i].start!.dy);
        Offset b = Offset(rectangles[i].start!.dx + rectangles[i].width!,
            rectangles[i].start!.dy);
        findPart(a, b, i, rectangles[j]);

        a = Offset(rectangles[i].start!.dx, rectangles[i].start!.dy);
        b = Offset(rectangles[i].start!.dx,
            rectangles[i].start!.dy + rectangles[i].height!);
        findPart(a, b, i, rectangles[j]);

        a = Offset(rectangles[i].start!.dx,
            rectangles[i].start!.dy + rectangles[i].height!);
        b = Offset(rectangles[i].start!.dx + rectangles[i].width!,
            rectangles[i].start!.dy + rectangles[i].height!);
        findPart(a, b, i, rectangles[j]);

        a = Offset(rectangles[i].start!.dx + rectangles[i].width!,
            rectangles[i].start!.dy);
        b = Offset(rectangles[i].start!.dx + rectangles[i].width!,
            rectangles[i].start!.dy + rectangles[i].height!);
        findPart(a, b, i, rectangles[j]);
      }
    }

    for (int i = 0; i < circles.length; i++) {
      List<Arc> visibleArcs = circles[i].getVisible();

      for (var arc in visibleArcs) {
        Rect rect = Rect.fromLTWH(circles[i].center!.dx, circles[i].center!.dy,
            circles[i].radius! * 2, circles[i].radius! * 2);
        canvas.drawArc(rect, arc.angle!, arc.length!, false, paint);
      }
    }

    for (int i = 0; i < rectangles.length; i++) {
      List<PartRectangle> visibleParts = rectangles[i].getVisible();

      for (var part in visibleParts) {
        canvas.drawLine(part.begin!, part.end!, paint);
      }
    }

    if (mode == 0) {
      final paintRed = Paint()
        ..color = Colors.red
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < circles.length; i++) {
        List<Arc> vis = circles[i].arcs;

        for (var v in vis) {
          Rect rect = Rect.fromCenter(
              center: Offset(circles[i].center!.dx, circles[i].center!.dy),
              width: circles[i].radius! * 2,
              height: circles[i].radius! * 2);
          canvas.drawArc(rect, v.angle!, v.length!, false, paintRed);
        }
      }

      for (int i = 0; i < rectangles.length; i++) {
        List<PartRectangle> vis = rectangles[i].parts;

        for (var v in vis) {
          canvas.drawLine(v.getStart(), v.getEnd(), paintRed);
        }
      }
    }
  }
}
