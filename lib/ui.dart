
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
  int indexCircle = 0;
  List<Offset> circles = <Offset>[const Offset(1, 1), const Offset(1, 1)];
  bool valueS = false;
  final controllerIdFigure = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Колонка с канвасам и регулировка размера
        upColumn(),
        /// Колонка с настройками
        downColumn()
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
                  CircleOne: circles[0],
                  CircleTwo: circles[1],
                )
            ),
          RotatedBox(
            quarterTurns: 1,
            child: SizedBox(
              width: 500,
              child: Slider(
                label: "Select Age",
                value: circles[indexCircle].dy,
                onChanged: (value) {
                  setState(() {
                    circles[indexCircle] = Offset(circles[indexCircle].dx, value);
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
            value: circles[indexCircle].dx,
            onChanged: (value) {
              setState(() {
                setState(() {
                  circles[indexCircle] = Offset(value, circles[indexCircle].dy);
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
                  indexCircle = 0;
                  break;
                case "1":
                  indexCircle = 1;
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
