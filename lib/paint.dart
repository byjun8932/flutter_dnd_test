import 'dart:math';

import 'package:flutter/material.dart';

class DnDTest extends StatefulWidget {
  const DnDTest({super.key});

  @override
  State<DnDTest> createState() => _DnDTestState();
}

class _DnDTestState extends State<DnDTest> {
  final List<Ball> _balls = [];
  double xPos = 50;
  double yPos = 50;
  bool isClick = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Drag and Drop"),
      // ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      xPos = Random().nextInt(850).toDouble();
                      yPos = Random().nextInt(850).toDouble();
                      _balls.add(Ball(xPosition: xPos, yPosition: yPos, ballRad: 20));
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    color: Colors.green,
                    child: const Center(
                      child: Text("새로운 ToDo 생성"),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onPanDown: (details) {
                      setState(() {
                        for (var ball in _balls) {
                          if (ball.isBallRegion(details.localPosition.dx, details.localPosition.dy)) {
                            isClick = true;
                            break;
                          }
                        }
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        isClick = false;
                      });
                    },
                    onPanUpdate: (details) {
                      if (isClick) {
                        setState(() {
                          for (var ball in _balls) {
                            if (ball.isBallRegion(details.localPosition.dx, details.localPosition.dy)) {
                              ball.xPosition = details.localPosition.dx;
                              ball.yPosition = details.localPosition.dy;
                              break;
                            }
                          }
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      color: Colors.lightBlueAccent,
                      child: CustomPaint(
                        painter: BallPainter(balls: _balls),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BallPainter extends CustomPainter {
  final List<Ball> balls;

  BallPainter({required this.balls});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.indigoAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var ball in balls) {
      canvas.drawCircle(Offset(ball.xPosition, ball.yPosition), ball.ballRad, paint);
    }

    // Draw the x and y axes
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Ball {
  double xPosition;
  double yPosition;
  final double ballRad;

  Ball({
    required this.xPosition,
    required this.yPosition,
    required this.ballRad,
  });

  bool isBallRegion(double checkX, double checkY) {
    return (pow(xPosition - checkX, 2) + pow(yPosition - checkY, 2)) <= pow(ballRad, 2);
  }
}
