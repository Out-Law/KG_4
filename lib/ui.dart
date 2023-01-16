import 'package:flutter/material.dart';

import 'canvas.dart';

class Ui extends StatefulWidget {
  const Ui({Key? key}) : super(key: key);

  @override
  State<Ui> createState() => _UiState();
}

class _UiState extends State<Ui> {
  double moveDx = 1;
  double moveDy = 1;
  bool valueS = false;
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

  Widget upColumn() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 800,
              height: 500,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blueAccent)),
              child: CanvasWidget(
                CircleOne: Offset(moveDx, moveDy),
                CircleTwo: const Offset(200, 200),
              )),
          RotatedBox(
            quarterTurns: 1,
            child: SizedBox(
              width: 500,
              child: Slider(
                label: "Select Age",
                value: moveDy,
                onChanged: (value) {
                  setState(() {
                    moveDy = value;
                  });
                },
                min: 1,
                max: 448,
              ),
            ),
          ),
        ]),
        SizedBox(
          width: 800,
          child: Slider(
            label: "Select Age",
            value: moveDx,
            onChanged: (value) {
              setState(() {
                moveDx = value;
              });
            },
            min: 1,
            max: 748,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        const TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Размер",
                fillColor: Colors.black12,
                filled: true)),
        SizedBox(
          height: 16,
        ),
        Container(
          height: 4,
          color: Colors.black,
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget downColumn() {
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
        const TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Размер",
                fillColor: Colors.black12,
                filled: true)),
        const SizedBox(
          height: 10,
        ),
        const TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Размер",
                fillColor: Colors.black12,
                filled: true)),
      ],
    );
  }
}
