import 'dart:math' show pi, sin, cos;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _sideController;
  late Animation<int> _sideAnimation;

  late AnimationController _radiusController;
  late Animation<double> _radiusAnimation;

  late AnimationController _rotationController;
  late Animation _rotationAnimation;

  @override
  void initState() {
    _sideController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _sideAnimation = IntTween(begin: 3, end: 10).animate(_sideController);

    _radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _radiusAnimation = Tween(begin: 20.0, end: 400.0)
        .chain(CurveTween(curve: Curves.bounceInOut))
        .animate(_radiusController);

    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _rotationAnimation = Tween<double>(begin: 0.0, end: pi * 2)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_rotationController);

    super.initState();
  }

  @override
  void dispose() {
    _sideController.dispose();
    _radiusController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _sideController.repeat(reverse: true);
    _radiusController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(50, 46, 45, 1),
        body: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _sideAnimation,
              _radiusAnimation,
              _rotationController,
            ]),
            builder: (BuildContext context, Widget? child) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateX(_rotationAnimation.value)
                  ..rotateY(_rotationAnimation.value)
                  ..rotateZ(_rotationAnimation.value),
                alignment: Alignment.center,
                child: CustomPaint(
                  painter: Polygon(sides: _sideAnimation.value),
                  // painter: Circle(),
                  child: SizedBox(
                      width: _radiusAnimation.value,
                      height: _radiusAnimation.value),
                ),
              );
            },
          ),
        ));
  }
}

class Polygon extends CustomPainter {
  final int sides;

  Polygon({required this.sides});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final path = Path();

    final centerOfCanvas = Offset(size.width / 2, size.height / 2);

    final angle = (2 * pi) / sides;

    final angles = List.generate(sides, (index) => index * angle);

    final radius = size.width / 2;

/*
x= centreOfCanvas.dx + radius * cos(angle)
y = centreOfCanvas.dy + radius * sin(angle)


 */

    path.moveTo(
      centerOfCanvas.dx + radius * cos(0),
      centerOfCanvas.dx + radius * sin(0),
    );

    for (var angle in angles) {
      path.lineTo(centerOfCanvas.dx + radius * cos(angle),
          centerOfCanvas.dy + radius * sin(angle));
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is Polygon && oldDelegate.sides != sides;
}

class Circle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final myPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3;

    final initialPositionOfCircle = Offset(size.width / 2, size.height / 3);

    const radiusOfCircle = 100.0;

    canvas.drawCircle(initialPositionOfCircle, radiusOfCircle, myPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
