import 'package:flutter/material.dart';
import 'package:highlight_player/Page/highlight_player.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HighlightPlayer(),
    );
  }
}
