import 'package:flutter/material.dart';
import 'package:queens_app/page/eight_queens_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '8 Queens',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: EightQueensPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
