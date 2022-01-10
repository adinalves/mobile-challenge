import 'package:flutter/material.dart';
import 'package:mobile_challenge/screens/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    MaterialApp(
      title: 'Desafio Plurall',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    ),
  );
}
