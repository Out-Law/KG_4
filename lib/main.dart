import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:kg/ui.dart';


Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var picture;


  var palet = List.generate(4, (i) => List<int>.filled(4,0), growable: false);
  late Uint8List data;

  Future<void> readByte() async {

    var fileName = '/home/outlaw/App/KG/lib/labaARGB.1';
    var bytes = await File(fileName).readAsBytes();

    var width = (bytes[0] << 8) | bytes[1];
    var height = (bytes[2] << 8) | bytes[3];
    var bit = bytes[4];
    var p_count = (bytes[5] << 8) & bytes[6];
    data = bytes.sublist(24, 49);

    for(int i = 0; i < 4; i++){
      for(int j = 0; j < 4; j++) {

        int temp = 0;
        temp = bytes[7 + (4*i+j) * 4] << 24;
        temp |= bytes[8 + (4*i+j) * 4] << 16;
        temp |= bytes[9 + (4*i+j) * 4] << 8;
        temp |= bytes[10 + (4*i+j) * 4];

        palet[i][j] = temp;
      }
    }

    for(int i = 0; i < 5; i++){
      /*for(int j = 0; j < 5; j++){
        picture =
    }*/
    }
  }

  @override
  void initState() {
    super.initState();
    readByte();
  }

  @override
  Widget build(BuildContext context) {

    final Color color = HexColor.fromHex('#FFB74093');

    print(color.toHex());
    print(Color(0xFFB74093).toHex());

    return const Scaffold(
      body: Ui()
    );


   /* Center(
      child: CustomPaint(
        painter: MyImage(data: data, palet: palet),
      ),
    ),*/
  }
}

class MyImage extends CustomPainter{
  Uint8List data;
  List<List<int>> palet;

  MyImage({required this.data, required this.palet});

  @override
  void paint(Canvas canvas, Size size) {
   /* int k = 0;
    int t = 0;
      for(int i = 0; i < data.length - 1; i++){
          Pixel(
              x: k.toDouble(),
              y: t.toDouble(),
              color: palet[data[i]&0xc000][data[i]&0x0300]
          );
          Pixel(
              x: k.toDouble(),
              y: t.toDouble() + 1,
              color: palet[data[i]&0x00c0][data[i]&0x0003]
          );
      }*/

    int k = 0;
    bool low = false;

    for(int i = 0; i < 5; i++){
      for(int j = 0; j < 5; j++){
        if(low){
          Pixel(x: i.toDouble(), y: j.toDouble(), color: palet[data[k]&0x00c0][0]);
        }
        else{

        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}

class Pixel extends CustomPainter {
  final double x;
  final double y;
  final int color;

  Pixel({required this.x, required this.y, required this.color});

  @override
  void paint(Canvas canvas, Size size) {

    canvas.drawRect(
        Rect.fromLTWH(x, y, 1, 1 ),
        Paint()..color = Color(color));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}




extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
        '${leadingHashSign ? '#' : ''}'
        '${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }