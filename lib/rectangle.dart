import 'dart:ui';

class PartRectangle {
  Offset? begin;
  Offset? end;

  PartRectangle(this.begin, this.end);

  Offset getStart() {
    return begin!;
  }

  Offset getEnd() {
    return end!;
  }

  void swap() {
    Offset temporary = begin!;
    begin = end;
    end = temporary;
  }
}

class Rectangle {
  int? width;
  int? height;
  Offset? start;

  List<PartRectangle> parts = <PartRectangle>[];

  Rectangle(this.width, this.height, this.start);

  void clear() {
    parts.clear();
  }

  Offset getStart() {
    return start!;
  }

  void addPart(Offset start, Offset end) {
    parts.add(PartRectangle(start, end));
  }

  void sort() {
    if (parts.isNotEmpty) {
      parts = parts.toSet().toList();
    }
  }

  List<PartRectangle> byX(
      PartRectangle parts, List<PartRectangle> result, int resX) {
    int y1 = parts.getStart().dx.toInt();
    int y2 = parts.getEnd().dy.toInt();

    if (y1 > y2) {
      int temp = y1;
      y1 = y2;
      y2 = temp;
    }

    List<PartRectangle> clear = result.toSet().toList();

    for (var res in clear) {
      if (res.getEnd().dy < res.getStart().dy) {
        res.swap();
      }

      if (y1 >= res.getStart().dy && y1 <= res.getEnd().dy) {
        if (y2 < res.getEnd().dy) {
          if (res.getStart().dy != y1) {
            result.add(PartRectangle(Offset(resX.toDouble(), res.getStart().dy),
                Offset(resX.toDouble(), y1.toDouble())));
          }
          if (res.getEnd().dy != y2) {
            result.add(PartRectangle(Offset(resX.toDouble(), y2.toDouble()),
                Offset(resX.toDouble(), res.getEnd().dy)));
          }
        } else if (y2 >= res.getEnd().dy) {
          result.add(PartRectangle(Offset(resX.toDouble(), res.getStart().dy),
              Offset(resX.toDouble(), y1.toDouble())));
        }
      } else if (y2 > res.getStart().dy && y2 < res.getEnd().dy) {
        result.add(PartRectangle(Offset(resX.toDouble(), y2.toDouble()),
            Offset(resX.toDouble(), res.getEnd().dy)));
      } else if (!(y1 <= res.getStart().dy && y2 >= res.getEnd().dy)) {
        result.add(PartRectangle(Offset(resX.toDouble(), res.getStart().dy),
            Offset(resX.toDouble(), res.getEnd().dy)));
      }
    }
    return result;
  }

  List<PartRectangle> byY(
      PartRectangle clip, List<PartRectangle> result, int resY) {
    int x1 = clip.getStart().dx.toInt();
    int x2 = clip.getEnd().dx.toInt();

    if (x1 > x2) {
      int temp = x1;
      x1 = x2;
      x2 = temp;
    }

    List<PartRectangle> clear = result.toSet().toList();

    for (var res in clear) {
      if (res.getEnd().dx < res.getStart().dx) {
        res.swap();
      }

      if (x1 >= res.getStart().dx && x1 <= res.getEnd().dx) {
        if (x2 < res.getEnd().dx) {
          if (res.getStart().dx != x1) {
            result.add(PartRectangle(Offset(res.getStart().dx, resY.toDouble()),
                Offset(x1.toDouble(), resY.toDouble())));
          }
          if (res.getEnd().dx != x2) {
            result.add(PartRectangle(Offset(x2.toDouble(), resY.toDouble()),
                Offset(res.getEnd().dx, resY.toDouble())));
          }
        } else if (x2 >= res.getEnd().dx) {
          result.add(PartRectangle(Offset(res.getStart().dx, resY.toDouble()),
              Offset(x1.toDouble(), resY.toDouble())));
        }
      } else if (x2 > res.getStart().dx && x2 < res.getEnd().dx) {
        result.add(PartRectangle(Offset(x2.toDouble(), resY.toDouble()),
            Offset(res.getEnd().dx, resY.toDouble())));
      } else if (!(x1 <= res.getStart().dx && x2 >= res.getEnd().dx)) {
        result.add(PartRectangle(Offset(res.getStart().dx, resY.toDouble()),
            Offset(res.getEnd().dx, resY.toDouble())));
      }
    }
    return result;
  }

  List<PartRectangle> getVisible() {
    sort();

    List<PartRectangle> result = <PartRectangle>[];

    result.add(PartRectangle(
        Offset(start!.dx, start!.dy), Offset(start!.dx + width!, start!.dy)));
    result.add(PartRectangle(
        Offset(start!.dx, start!.dy), Offset(start!.dx, start!.dy + height!)));
    result.add(PartRectangle(Offset(start!.dx, start!.dy + height!),
        Offset(start!.dx + width!, start!.dy + height!)));
    result.add(PartRectangle(Offset(start!.dx + width!, start!.dy),
        Offset(start!.dx + width!, start!.dy + height!)));

    if (parts.isNotEmpty) {
      for (var part in parts) {
        if (part.getStart().dx == start!.dx && part.getEnd().dx == start!.dx) {
          byX(part, result, start!.dx.toInt());
        } else if (part.getStart().dx == start!.dx + width! &&
            part.getEnd().dx == start!.dx + width!) {
          byX(part, result, (start!.dx + width!.toDouble()).toInt());
        } else if (part.getStart().dy == start!.dy &&
            part.getEnd().dy == start!.dy) {
          byY(part, result, start!.dy.toInt());
        } else if (part.getStart().dy == start!.dy + height! &&
            part.getEnd().dy == start!.dy + height!) {
          byY(part, result, (start!.dy + height!.toDouble()).toInt());
        }
      }
    }

    return result;
  }
}
