
import 'package:flutter/material.dart';

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
  List<Offset> figures = <Offset>[const Offset(1, 1), const Offset(1, 1),
    const Offset(1, 1), const Offset(1, 1), const Offset(1, 1)];
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
                  CircleOne: figures[0],
                  CircleTwo: figures[1],
                  RectangleOne: figures[2],
                  RectangleTwo: figures[3],
                  RectangleThree: figures[4],
                )
            ),
          RotatedBox(
            quarterTurns: 1,
            child: SizedBox(
              width: 500,
              child: Slider(
                label: "Select Age",
                value: figures[indexFigure].dy,
                onChanged: (value) {
                  setState(() {
                    figures[indexFigure] = Offset(figures[indexFigure].dx, value);
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
                  value: figures[indexFigure].dy,
                  onChanged: (value) {
                    setState(() {
                      figures[indexFigure] = Offset(figures[indexFigure].dx, value);
                    });
                  },
                  min: 1,
                  max: 448,
                ),
              ),
            ),
        ]
        ),

        SizedBox(
          width: 800,
          child: Slider(
            label: "Select Age",
            value: figures[indexFigure].dx,
            onChanged: (value) {
              setState(() {
                setState(() {
                  figures[indexFigure] = Offset(value, figures[indexFigure].dy);
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
            value: figures[indexFigure].dx,
            onChanged: (value) {
              setState(() {
                setState(() {
                  figures[indexFigure] = Offset(value, figures[indexFigure].dy);
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
