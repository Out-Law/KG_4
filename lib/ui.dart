import 'package:flutter/material.dart';

import 'canvas.dart';

class Ui extends StatefulWidget {
  const Ui({Key? key}) : super(key: key);

  @override
  State<Ui> createState() => _UiState();
}

class _UiState extends State<Ui> {
  int age = 10;
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


  Widget upColumn(){
    return Column(
      children: [
        Container(
            width: 800,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
                border: Border.all(color: Colors.blueAccent)
            ),
            child: const CanvasWidget()
        ),
        SizedBox(
          width: 800,
          child: Slider(
            label: "Select Age",
            value: age.toDouble(),
            onChanged: (value) {
              setState(() {
                age = value.toInt();
              });
            },
            min: 5,
            max: 100,
          ),
        ),
      ],
    );
  }

  Widget downColumn(){
    return Column(
      children: [
        Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ), //SizedBox
            const Text(
              'Library Implementation Of Searching Algorithm: ',
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
            ), //Checkbox
          ], //<Widget>[]
        ),
      ],
    );
  }
}
