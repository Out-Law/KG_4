import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'rectangle.dart';
import 'circle.dart';

class CanvasWidget extends StatefulWidget {
  Offset CircleOne = const Offset(0, 0);
  Offset CircleTwo = const Offset(0, 0);

  Offset RectangleOne = const Offset(0, 0);
  Offset RectangleTwo = const Offset(0, 0);
  Offset RectangleThree = const Offset(0, 0);

  CanvasWidget(
      {Key? key,
      required this.CircleOne,
      required this.CircleTwo,
      required this.RectangleOne,
      required this.RectangleTwo,
      required this.RectangleThree})
      : super(key: key);

  @override
  _CanvasWidgetState createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true,
      painter: CanvasPainter(widget.CircleOne, widget.CircleTwo,
          widget.RectangleOne, widget.RectangleTwo, widget.RectangleThree),
    );
  }
}

class CanvasPainter extends CustomPainter {
  List<Offset> points = <Offset>[];
  List<Offset> pointsCircle = <Offset>[];
  Offset CircleOne = const Offset(0, 0);
  Offset CircleTwo = const Offset(0, 0);

  int mode = 0;

  Offset RectangleOne = const Offset(0, 0);
  Offset RectangleTwo = const Offset(0, 0);
  Offset RectangleThree = const Offset(0, 0);

  CanvasPainter(this.CircleOne, this.CircleTwo, this.RectangleOne,
      this.RectangleTwo, this.RectangleThree);

  List<Rectangle> rectangles = <Rectangle>[];
  List<Circle> circles = <Circle>[];

  @override
  void paint(Canvas canvas, Size size) {
    drawRectangle(
        canvas, const Size(250, 300), RectangleOne.dx, RectangleOne.dy);
    drawRectangle(canvas, const Size(50, 50), RectangleTwo.dx, RectangleTwo.dy);
    drawRectangle(
        canvas, const Size(400, 75), RectangleThree.dx, RectangleThree.dy);
    drawCircle(canvas, Offset(CircleOne.dx + 25, CircleOne.dy + 25), 25);
    drawCircle(canvas, Offset(CircleTwo.dx + 100, CircleTwo.dy + 100), 100);
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

  int codePack(int xl, int xp, int yn, int yv, Offset a) {
    return (a.dx < xl ? 1 : 0) +
        (a.dx > xp ? 2 : 0) +
        (a.dy < yv ? 4 : 0) +
        (a.dy > yn ? 8 : 0);
  }

  //точки прямой, порядковый номер прямоугольника, которому принадледит прямая, окно видимости
  void alClipping(Offset a, Offset b, int i, Rectangle rec) {
    Offset copya = a;
    Offset copyb = b;

    Offset c;
    //Алгоритм отсечения Сазерленда-Коэна
    //для ортогонального окна 6
    int xl = rec.getOffset().dx.toInt();
    int yv = rec.getOffset().dy.toInt();
    int xp = rec.getOffset().dx.toInt() + rec.getWidht();
    int yn = rec.getOffset().dy.toInt() + rec.getHeight();

    //код концов отрезка
    int code_a, code_b, code;

    code_a = codePack(xl, xp, yn, yv, a);
    code_b = codePack(xl, xp, yn, yv, b);

    //если 2 прямой не лежат по одну сторону от окна
    if (code_a != 0 && code_b != 0) {
      //если две точки находятся по одну сторону
      if (((code_a & 8) != 0 && (code_b & 8) != 0 ||
          (code_b & 4) != 0 && (code_a & 4) != 0 ||
          (code_a & 1) != 0 && (code_b & 1) != 0 ||
          (code_a & 2) != 0 && (code_b & 2) != 0)) {
        rectangles[i].addPart(copya, copyb);
        return;
      }

      //если две точки не находятся в противоположных сторонах друг от друга
      if (!((code_a & 8) != 0 && (code_b & 4) != 0 ||
          (code_b & 8) != 0 && (code_a & 4) != 0 ||
          (code_a & 1) != 0 && (code_b & 2) != 0 ||
          (code_a & 2) != 0 && (code_b & 1) != 0)) {
        return;
      }
    }

    while ((code_a | code_b) != 0) {
      // выбираем точку c с ненулевым кодом
      if (code_a != 0) {
        code = code_a;
        c = a;
      } else {
        code = code_b;
        c = b;
      }

      //если с левее окна, то передвигаем c на прямую x = хл
      //если c правее окна, то передвигаем c на прямую x = хп

      if ((code & 1) != 0) {
        c = Offset(xl.toDouble(), c.dy);
      } else if ((code & 2) != 0) {
        c = Offset(xp.toDouble(), c.dy);
      }
      // если c ниже окна, то передвигаем c на прямую y = yn
      //если c выше окна, то передвигаем c на прямую y = yv
      else if ((code & 4) != 0) {
        c = Offset(c.dx, yv.toDouble());
      } else if ((code & 8) != 0) {
        c = Offset(c.dx, yn.toDouble());
      }

      //обновляем код
      if (code == code_a) {
        code_a = codePack(xl, xp, yn, yv, c);
        a = c;
      } else {
        code_b = codePack(xl, xp, yn, yv, c);
        b = c;
      }
    }
    //отсылаем кусок стороны, которую не видно
    if (copya != a) {
      rectangles[i].addPart(copya, a);
    }
    if (copyb != b) {
      rectangles[i].addPart(b, copyb);
    }
  }

  List<Offset> getIntersectionOfTwoCircles(
      Offset circle1, int radius1, Offset circle2, int radius2) {
    Offset p1 = Offset(-1, -1);
    Offset p2 = Offset(-1, -1);

    // Уравнение окружности 1
    int xCoeffEq1 = 2 * (-circle1.dx.toInt());
    int xAbsoluteTermEq1 = (circle1.dx * circle1.dx).toInt();

    int yCoeffEq1 = 2 * (-circle1.dy.toInt());
    int yAbsoluteTermEq1 = (circle1.dy * circle1.dy).toInt();

    int totalAbsoluteTermEq1 =
        xAbsoluteTermEq1 + yAbsoluteTermEq1 - radius1 * radius1;

    // Уравнение окружности 2
    int xCoeffEq2 = 2 * (-circle2.dx.toInt());
    int xAbsoluteTermEq2 = (circle2.dx * circle2.dx).toInt();

    int yCoeffEq2 = 2 * (-circle2.dy.toInt());
    int yAbsoluteTermEq2 = (circle2.dy * circle2.dy).toInt();

    int totalAbsoluteTermEq2 =
        xAbsoluteTermEq2 + yAbsoluteTermEq2 - radius2 * radius2;

    // Вычитаем уравнение 2 из уравнения 1
    // 4x - 6y - 16 = 0 - получаем в итоге
    int shortedXCoef = xCoeffEq1 - xCoeffEq2; // 4x
    int shortedYCoef = yCoeffEq1 - yCoeffEq2; // -6y
    int shortedAbsoluteTerm =
        totalAbsoluteTermEq1 - totalAbsoluteTermEq2; // -16

    if (shortedXCoef != 0) {
      // 4x - 6y - 16 = 0 в x = (6y + 16)/4 => x = 1.5y + 4;
      // double reducedXCoefRelativeX = 1.0; // x
      double reducedYCoefRelativeX =
          -(shortedYCoef.toDouble() / shortedXCoef); // 6y / 4 = 1.5y;
      double reducedAbsoluteTermRelativeX =
          -(shortedAbsoluteTerm.toDouble() / shortedXCoef); // 16 / 4 = 4;

      // x^2 = (1.5y + 4)^2, раскрываем этот квадрат и находим коэффициенты ay^2 + by + c
      double aCoefInReplacedDoubledX =
          reducedYCoefRelativeX * reducedYCoefRelativeX; // (1.5y)^2 = 2.25y^2
      double bCoefInReplacedDoubledX = 2 *
          reducedYCoefRelativeX *
          reducedAbsoluteTermRelativeX; // 2 * 1.5y * 4 = 12y;
      double cCoefInReplacedDoubledX = reducedAbsoluteTermRelativeX *
          reducedAbsoluteTermRelativeX; // 4 * 4 = 16;

      // Т.к. мы будем подставлять в уравнение 1, то смотрим на коэффициент X в переменной xCoeffEq1
      // -2x = -2*(1.5y + 4)
      double aCoefInReplacedX =
          xCoeffEq1 * reducedYCoefRelativeX; // -2 * 1.5y = -3y
      double bCoefInReplacedX =
          xCoeffEq1 * reducedAbsoluteTermRelativeX; // -2 * 4 = -8

      // 3,25y^2 + 7y + 1 = 0
      double finalACoef =
          aCoefInReplacedDoubledX + 1; // 2.25y^2 + y^2 = 3.25y^2
      double finalBCoef = bCoefInReplacedDoubledX +
          aCoefInReplacedX +
          yCoeffEq1; // 12y - 3y - 2y = 7y
      double finalCCoef = cCoefInReplacedDoubledX +
          bCoefInReplacedX +
          totalAbsoluteTermEq1; // 16 - 8 - 7 = 1

      // D = b^2 - 4ac
      double discriminant =
          finalBCoef * finalBCoef - 4 * finalACoef * finalCCoef;

      if (discriminant > 0) {
        // x1 = (-b + sqrt(D) ) / 2a
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

      double aCoefInReplacedY = yCoeffEq1 * reducedXCoefRelativeY;
      double bCoefInReplacedY = yCoeffEq1 * reducedAbsoluteTermRelativeY;

      double finalACoef = aCoefInReplacedDoubledY + 1;
      double finalBCoef =
          bCoefInReplacedDoubledY + aCoefInReplacedY + xCoeffEq1;
      double finalCCoef =
          cCoefInReplacedDoubledY + bCoefInReplacedY + totalAbsoluteTermEq1;

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

  List<Offset> getIntersectionOfLineAndCircle(Offset circleCenter,
      int circleRadius, Offset linePoint1, Offset linePoint2) {
    Offset p1 = Offset(-1, -1);
    Offset p2 = Offset(-1, -1);

    // Т.к. мы накладываем ортогональные окна,
    // то у каждой прямой будут равны либо координаты по одной из осей
    if (linePoint1.dy == linePoint2.dy) {
      double y = linePoint1.dy;

      // (x-1)^2 + (y-1)^2 = 3^2 -> x^2 - 2x + 1 + (y-1)^2 = 3^2
      int xDoubledCoeff = 1; // x^2
      int xSingleCoeff = 2 * (-circleCenter.dx.toInt()); // -1 * 2 * x = -2x
      int xAbsoluteTerm =
          (circleCenter.dx * circleCenter.dx).toInt(); // 1 * 1 = 1

      // x^2 - 2x + 1 + (3-1)^2 - 3^2 = 0
      // x^2 - 2x - 4 = 0;
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

      // (x-1)^2 + (y-1)^2 = 3^2 -> (x-1)^2 + y^2 - 2y + 1 = 3^2
      int yDoubledCoeff = 1; // x^2
      int ySingleCoeff = 2 * (-circleCenter.dy.toInt()); // // -1 * 2 * x = -2x
      int yAbsoluteTerm =
          (circleCenter.dy * circleCenter.dy).toInt(); // 1 * 1 = 1

      // (2-1)^2 + y^2 - 2y + 1 - 3^2 = 0
      // y^2 - 2y - 7 = 0;
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

    return <Offset>[p1, p2];
  }

  //определение стороны по которую лежит точка относительно прямой, организованной 2мя точками
  int orien(Offset a, Offset b, Offset c) {
    //точка центра прмяой
    Offset m = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);

    //точка слева - 1
    //точка справа - 2
    //точка сверху - 4
    //точка снизу - 8

    return (m.dx > c.dx ? 1 : 0) +
        (m.dx < c.dx ? 2 : 0) +
        (m.dx < c.dy ? 4 : 0) +
        (m.dy > c.dy ? 8 : 0);
  }

  void Draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    //найти пересения, принимая, что на каждой итерации нижний и верхний слой целые и ничем ранее не перекрыты
    //нахождение перекрытх частей окружностей окружностями (слои от 1 до 3 с слоями от 2 до 4)
    for (int i = 0; i < circles.length - 1; i++) {
      for (int j = 1 + i; j < circles.length; j++) {
        Offset circi = circles[i].center!;
        Offset circj = circles[j].center!;
        int radi = circles[i].radius!;
        int radj = circles[j].radius!;

        List<Offset> mac =
            getIntersectionOfTwoCircles(circi, radi, circj, radj);

        //если 2 точки пересечения
        if (mac[0] != Offset(-1, -1) && mac[1] != Offset(-1, -1)) {
          bool mod = false;
          int x1 = orien(mac[0], mac[1], circj);
          int x2 = orien(mac[0], mac[1], circi);

          if ((x1 & x2) != 0 && radi < radj) {
            mod = true;
          }

          circles[i].addArc(mac[0], mac[1], mod);
        } else
        //добавить добавление всей окружности если нижняя лежит полностю под верхней
        if (radi <= radj &&
            circi.dx >= (circj.dx - radj) &&
            circi.dx <= (circj.dy + radj) &&
            circi.dy >= (circj.dy - radj) &&
            circi.dy <= (circj.dy + radj)) {
          circles[i].addArcAllCircle();
        }
      }
    }

    //нахождение перекрытых частей окружностей прямоугольниками (слои от 1 до 4 с слоями от 5 до 7)

    //ДОБАВИТЬ ВЗАИМОДЕЙСТВИЕ МЕЖДУ ОКНАМИ И ОКРУЖНОСТЯМИ
    for (int i = 0; i < circles.length; i++) {
      for (int j = 0; j < rectangles.length; j++) {
        //для стороны 1: верхней
        Offset a =
            Offset(rectangles[j].getOffset().dx, rectangles[j].getOffset().dy);
        Offset b = Offset(
            rectangles[j].getOffset().dx + rectangles[j].getWidht(),
            rectangles[j].getOffset().dy);
        List<Offset> mac = getIntersectionOfLineAndCircle(
            circles[i].center!, circles[i].radius!, a, b);

        //для стороны 2 левой
        a = Offset(rectangles[j].getOffset().dx, rectangles[j].getOffset().dy);
        b = Offset(rectangles[j].getOffset().dx,
            rectangles[j].getOffset().dy + rectangles[j].getHeight());
        mac = getIntersectionOfLineAndCircle(
            circles[i].center!, circles[i].getRadius(), a, b);

        //для стороны 3 нижней
        a = Offset(rectangles[j].getOffset().dx,
            rectangles[j].getOffset().dy + rectangles[j].getHeight());
        b = Offset(rectangles[j].getOffset().dx + rectangles[j].getWidht(),
            rectangles[j].getOffset().dy + rectangles[i].getHeight());
        mac = getIntersectionOfLineAndCircle(
            circles[i].center!, circles[i].getRadius(), a, b);

        //для стороны 4 правой
        a = Offset(rectangles[j].getOffset().dx + rectangles[i].getWidht(),
            rectangles[j].getOffset().dy);
        b = Offset(rectangles[j].getOffset().dx + rectangles[i].getWidht(),
            rectangles[j].getOffset().dy + rectangles[i].getHeight());
        mac = getIntersectionOfLineAndCircle(
            circles[i].center!, circles[i].getRadius(), a, b);
      }
    }

    //нахождение перекрытых частей прямоугольников прямоугольниками (слои от 5 до 7 с слоями от 6 до 7)
    for (int i = 0; i < rectangles.length - 1; i++) {
      //для каждой стороны рассматриваемого прямоугольника решаем задачу отчесения ортогональным окном
      for (int j = 1 + i; j < rectangles.length; j++) {
        //для стороны 1: , Offset(_point.X + _width, _point.dy))
        Offset a =
            Offset(rectangles[i].getOffset().dx, rectangles[i].getOffset().dy);
        Offset b = Offset(
            rectangles[i].getOffset().dx + rectangles[i].getWidht(),
            rectangles[i].getOffset().dy);
        alClipping(a, b, i, rectangles[j]);

        //для стороны 2 Offset(_point.X, _point.dy), Offset(_point.X, _point.dy + _height))
        a = Offset(rectangles[i].getOffset().dx, rectangles[i].getOffset().dy);
        b = Offset(rectangles[i].getOffset().dx,
            rectangles[i].getOffset().dy + rectangles[i].getHeight());
        alClipping(a, b, i, rectangles[j]);

        //для стороны 3 Offset(_point.X, _point.dy + _height), Offset(_point.X + _width, _point.dy + _height)
        a = Offset(rectangles[i].getOffset().dx,
            rectangles[i].getOffset().dy + rectangles[i].getHeight());
        b = Offset(rectangles[i].getOffset().dx + rectangles[i].getWidht(),
            rectangles[i].getOffset().dy + rectangles[i].getHeight());
        alClipping(a, b, i, rectangles[j]);

        //для стороны 4 (Offset(_point.X + _width, _point.dy), Offset(_point.X + _width, _point.dy + _height))
        a = Offset(rectangles[i].getOffset().dx + rectangles[i].getWidht(),
            rectangles[i].getOffset().dy);
        b = Offset(rectangles[i].getOffset().dx + rectangles[i].getWidht(),
            rectangles[i].getOffset().dy + rectangles[i].getHeight());
        alClipping(a, b, i, rectangles[j]);
      }
    }

    //отрисовать видимые части
    for (int i = 0; i < circles.length; i++) {
      List<Arc> vis = circles[i].getVisible();

      for (var v in vis) {
        Rect rect = Rect.fromCenter(
            center:
                Offset(circles[i].getOffset().dx, circles[i].getOffset().dy),
            width: circles[i].getRadius() * 2,
            height: circles[i].getRadius() * 2);
        canvas.drawArc(rect, v.angle!, v.length!, true, paint);
      }
    }

    for (int i = 0; i < rectangles.length; i++) {
      List<PartRectangle> vis = rectangles[i].getVisible();

      for (var v in vis) {
        canvas.drawLine(v.getStart(), v.getEnd(), paint);
      }
    }

    //отрисовать перекрытые части
    //если mode = 0, то добавить режим Б
    if (mode == 0) {
      final paintRed = Paint()
        ..color = Colors.red
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < circles.length; i++) {
        List<Arc> vis = circles[i].getArcs();

        for (var v in vis) {
          Rect rect = Rect.fromCenter(
              center:
                  Offset(circles[i].getOffset().dx, circles[i].getOffset().dy),
              width: circles[i].getRadius() * 2,
              height: circles[i].getRadius() * 2);
          canvas.drawArc(rect, v.angle!, v.length!, true, paintRed);
        }
      }

      for (int i = 0; i < rectangles.length; i++) {
        List<PartRectangle> vis = rectangles[i].getParts();

        for (var v in vis) {
          canvas.drawLine(v.getStart(), v.getEnd(), paintRed);
        }
      }
    }

    // pictureBox1.Image = bitmap;
  }

  // //Начальная инициализация каждого кадра
  // void pictureBox1_Paint(object sender, PaintEventArgs e)
  // {
  //     base.OnPaint(e);
  //     bitmap = new Bitmap(pictureBox1.Width, pictureBox1.Height);
  //     graphics = Graphics.FromImage(bitmap);
  //     graphics.Clear(backColor);
  // }

  //если mode = 1, то режим А
  //если mode = 0, то режим Б
  // void checkBox1_CheckedChanged(object sender, EventArgs e)
  // {
  //     //если галочка на А
  //     if (checkBox1.Checked)
  //     {
  //         mode = 1;
  //         checkBox2.Checked = false;
  //     } else
  //     {
  //         mode = 0;
  //         checkBox2.Checked = true;
  //     }

  //     Draw();
  // }
  // void checkBox2_CheckedChanged(object sender, EventArgs e)
  // {
  //     //если галочка на Б
  //     if (checkBox2.Checked)
  //     {
  //         mode = 0;
  //         checkBox1.Checked = false;
  //     }
  //     else
  //     {
  //         mode = 1;
  //         checkBox1.Checked = true;
  //     }

  //     Draw();
  // }
  // void Form1_Load(object sender, EventArgs e)
  // {
  //     trackValue = trackBar1.Value;
  //     circles = new List<Circle>();

  //     //нужно заменить на рандом в промежутке от 0 до pictureBox1.Height - 2*(int)numericUpDown1.Value
  //     int y1 = rand.Next() % (pictureBox1.Height - 2 * (int)numericUpDown1.Value);
  //     int y2 = rand.Next() % (pictureBox1.Height - 2 * (int)numericUpDown2.Value);
  //     int y3 = rand.Next() % (pictureBox1.Height - 2 * (int)numericUpDown4.Value);
  //     int y4 = rand.Next() % (pictureBox1.Height - 2 * (int)numericUpDown5.Value);

  //     circles.Add(new Circle((int)numericUpDown1.Value, Offset(zeroX, y1)));
  //     circles.Add(new Circle((int)numericUpDown2.Value, Offset(zeroX, y2)));
  //     circles.Add(new Circle((int)numericUpDown4.Value, Offset(zeroX, y3)));
  //     circles.Add(new Circle((int)numericUpDown5.Value, Offset(zeroX, y4)));

  //     rectangles = new List<Rectangle>();

  //     int y5 = rand.Next() % (pictureBox1.Height - (int)numericUpDown6.Value);
  //     int y6 = rand.Next() % (pictureBox1.Height - (int)numericUpDown7.Value);
  //     int y7 = rand.Next() % (pictureBox1.Height - (int)numericUpDown3.Value);

  //     rectangles.Add(new Rectangle((int)numericUpDown8.Value, (int)numericUpDown6.Value, Offset(zeroX, y5)));
  //     rectangles.Add(new Rectangle((int)numericUpDown9.Value, (int)numericUpDown7.Value, Offset(zeroX, y6)));
  //     rectangles.Add(new Rectangle((int)numericUpDown10.Value, (int)numericUpDown3.Value, Offset(zeroX, y7)));
  // }
}
