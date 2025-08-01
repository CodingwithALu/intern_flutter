import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TriangleDragDemo());
  }
}

class TriangleDragDemo extends StatefulWidget {
  const TriangleDragDemo({super.key});

  @override
  State<TriangleDragDemo> createState() => _TriangleDragDemoState();
}

class _TriangleDragDemoState extends State<TriangleDragDemo> {
  // Tọa độ 3 đỉnh tam giác
  List<Offset> points = [
    const Offset(150, 500),
    const Offset(300, 150),
    const Offset(500, 500),
  ];

  int? draggingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (_, constraints) => GestureDetector(
          onPanStart: (details) {
            // Xác định xem người dùng bấm gần đỉnh nào nhất
            for (int i = 0; i < 3; i++) {
              if ((points[i] - details.localPosition).distance < 30) {
                draggingIndex = i;
                break;
              }
            }
          },
          onPanUpdate: (details) {
            if (draggingIndex != null) {
              setState(() {
                points[draggingIndex!] = details.localPosition;
              });
            }
          },
          onPanEnd: (_) => draggingIndex = null,
          child: CustomPaint(
            painter: TrianglePainter(points),
            child: SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final List<Offset> points;
  TrianglePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.teal[800]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintCircle = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;

    // Vẽ tam giác
    final path = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..close();
    canvas.drawPath(path, paintLine);

    // Vẽ 3 đỉnh (circle)
    for (var p in points) {
      canvas.drawCircle(p, 25, paintCircle);
      canvas.drawCircle(p, 25, paintLine); // Viền ngoài
    }
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) =>
      oldDelegate.points != points;
}
