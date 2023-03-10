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
      home: const Scaffold(
          body: Ui()
      ),
    );
  }
}

