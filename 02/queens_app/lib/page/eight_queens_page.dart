// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:queens_app/page/solve_queens.dart';

class EightQueensPage extends StatefulWidget {
  const EightQueensPage({super.key});

  @override
  _EightQueensPageState createState() => _EightQueensPageState();
}

class _EightQueensPageState extends State<EightQueensPage> {
  late final List<List<int>> solutions;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    solutions = solveNQueens(8);
  }

  void onSwipeLeft() {
    setState(() {
      currentIndex = (currentIndex + 1) % solutions.length;
    });
  }

  void onSwipeRight() {
    setState(() {
      currentIndex = (currentIndex - 1 + solutions.length) % solutions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final board = solutions[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '8 Queens - Solution ${currentIndex + 1}/${solutions.length}',
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! < 0) {
              onSwipeLeft();
            } else if (details.primaryVelocity! > 0) {
              onSwipeRight();
            }
          }
        },
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemCount: 64,
              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int col = index % 8;
                bool isQueen = board[row] == col;
                bool isWhite = (row + col) % 2 == 0;
                return Container(
                  decoration: BoxDecoration(
                    color: isWhite ? Color(0xFFF0D9B5) : Color(0xFFB58863),
                    border: Border.all(color: Colors.black12, width: 0.5),
                  ),
                  child: isQueen
                      ? Center(
                          child: Text(
                            '♛',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.purple[900],
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
