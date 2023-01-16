
import 'package:flutter/material.dart';
import 'package:kg/circle.dart';
import 'package:kg/rectangle.dart';

import 'canvas.dart';

class Ui extends StatefulWidget {
  const Ui({Key? key}) : super(key: key);

  @override
  State<Ui> createState() => _UiState();
}

class _UiState extends State<Ui> {
  double moveDy = 1;
  double moveDx = 1;
  int indexFigure = 0;

  List<Rectangle> rectangles = <Rectangle>[
    Rectangle(250, 300, const Offset(100, 100)),
    Rectangle(250, 300, const Offset(200, 200)),
    Rectangle(250, 300, const Offset(300, 300))
  ];
  List<Circle> circles = <Circle>[
    Circle(radius: 25, offset: const Offset(100, 100)),
    Circle(radius: 100, offset: const Offset(400, 400))
  ];

  bool valueS = false;
  final controllerIdFigure = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Колонка с канвасам и регулировка размера
        upColumn(),
        /// Колонка с настройками
        //downColumn()
      ],
    );
  }


  Widget upColumn(){
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 800,
                height: 500,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blueAccent)
                ),
                child: CanvasWidget(
                  rectangles: rectangles,
                  circles: circles,
                )
            ),
          RotatedBox(
            quarterTurns: 1,
            child: SizedBox(
              width: 500,
              child: Slider(
                label: "Select Age",
                value: rectangles[indexFigure].start!.dy,
                onChanged: (value) {
                  setState(() {
                    rectangles[indexFigure].start = Offset(rectangles[indexFigure].start!.dx, value);
                  });
                },
                min: 1,
                max: 448,
              ),
            ),
          ),

            const SizedBox(
              width: 16,
            ),

            RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                width: 500,
                child: Slider(
                  label: "Select Age",
                  activeColor: Colors.red,
                  thumbColor: Colors.red,
                  value: rectangles[indexFigure].height!.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      rectangles[indexFigure].height = value.toInt();
                    });
                  },
                  min: 1,
                  max: 400,
                ),
              ),
            ),
        ]
        ),

        SizedBox(
          width: 800,
          child: Slider(
            label: "Select Age",
            value: rectangles[indexFigure].start!.dx,
            onChanged: (value) {
              setState(() {
                setState(() {
                  rectangles[indexFigure].start = Offset(value, rectangles[indexFigure].start!.dy);
                });
              });
            },
            min: 1,
            max: 748,
          ),
        ),

        const SizedBox(
          height: 16,
        ),

        SizedBox(
          width: 800,
          child: Slider(
            label: "Select Age",
            activeColor: Colors.red,
            thumbColor: Colors.red,
            value: rectangles[indexFigure].width!.toDouble(),
            onChanged: (value) {
              setState(() {
                setState(() {
                  rectangles[indexFigure].width = value.toInt();
                });
              });
            },
            min: 1,
            max: 800,
          ),
        ),


        const SizedBox(
          height: 16,
        ),


        TextField(
            controller: controllerIdFigure,
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "ID фигуры",
                fillColor: Colors.black12,
                filled: true
            )
        ),

        const SizedBox(
          height: 16,
        ),

        ElevatedButton(
          child: const Text(
            'OK',
          ),
          onPressed: () {
            setState(() {
              switch(controllerIdFigure.text){
                case "0":
                  indexFigure = 0;
                  break;
                case "1":
                  indexFigure = 1;
                  break;
                case "2":
                  indexFigure = 2;
                  break;
                case "3":
                  indexFigure = 3;
                  break;
                case "4":
                  indexFigure = 4;
                  break;
              }
            });
          },
        ),

        const SizedBox(
          height: 16,
        ),

        Container(
          height: 4,
          color: Colors.black,
        ),

        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget  downColumn(){
    return Column(
      children: [
        Row(
          children: <Widget>[
            Checkbox(
              value: valueS,
              onChanged: (bool? value) {
                setState(() {
                  valueS = value!;
                });
              },
            ),
            const SizedBox(
              width: 10,
            ), //SizedBox
            const Text(
              '1 - Прямоугольник',
              style: TextStyle(fontSize: 17.0),
            ), //Text
            const SizedBox(width: 10), //SizedBox
            Checkbox(
              value: valueS,
              onChanged: (bool? value) {
                setState(() {
                  valueS = value!;
                });
              },
            ),

            ///

            const SizedBox(
              width: 10,
            ), //SizedBox
            const Text(
              '2 - Прямоугольник',
              style: TextStyle(fontSize: 17.0),
            ), //Text
            const SizedBox(width: 10), //SizedBox
            Checkbox(
              value: valueS,
              onChanged: (bool? value) {
                setState(() {
                  valueS = value!;
                });
              },
            ),

            ///

            const SizedBox(
              width: 10,
            ),
            const Text(
              '3 - Прямоугольник',
              style: TextStyle(fontSize: 17.0),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          children: <Widget>[
            Checkbox(
              value: valueS,
              onChanged: (bool? value) {
                setState(() {
                  valueS = value!;
                });
              },
            ),
            const SizedBox(
              width: 10,
            ), //SizedBox
            const Text(
              '1 - Прямоугольник',
              style: TextStyle(fontSize: 17.0),
            ), //Text
            const SizedBox(width: 10), //SizedBox
            Checkbox(
              value: valueS,
              onChanged: (bool? value) {
                setState(() {
                  valueS = value!;
                });
              },
            ),

            ///

            const SizedBox(
              width: 10,
            ), //SizedBox
            const Text(
              '2 - Прямоугольник',
              style: TextStyle(fontSize: 17.0),
            ), //Text
            const SizedBox(width: 10), //SizedBox
            Checkbox(
              value: valueS,
              onChanged: (bool? value) {
                setState(() {
                  valueS = value!;
                });
              },
            ),

            ///

            const SizedBox(
              width: 10,
            ), //SizedBox
            const Text(
              '2 - Прямоугольник',
              style: TextStyle(fontSize: 17.0),
            ), //Text
            const SizedBox(width: 10), //SizedBox
            Checkbox(
              value: valueS,
              onChanged: (bool? value) {
                setState(() {
                  valueS = value!;
                });
              },
            ),

            ///

            const SizedBox(
              width: 10,
            ),
            const Text(
              '3 - Прямоугольник',
              style: TextStyle(fontSize: 17.0),
            ),
          ],
        ),

        const TextField(decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Размер",
            fillColor: Colors.black12,
            filled: true
        )),

        const SizedBox(
          height: 10,
        ),

        const TextField(decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Размер",
            fillColor: Colors.black12,
            filled: true
        )),

        const SizedBox(
          height: 10,
        ),

        ElevatedButton(
          child: const Text(
            'OK',
          ),
          onPressed: () {

          },
        ),
      ],
    );
  }
}
