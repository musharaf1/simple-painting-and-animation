import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    debugShowMaterialGrid: false,
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      drawer: Material(
        child: Container(
          color: const Color(0xff24283b),
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 100, top: 100),
              itemCount: 18,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'item $index',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Drawer"),
        ),
        body: Container(
          color: const Color(0xff414868),
          child: CustomPaint(
            painter: Trapezium(),
          ),
        ),
      ),
    );
  }
}

class Trapezium extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final shapePath = Path();
    const margin = 50.0;

    shapePath.moveTo(margin, 300);
    shapePath.relativeLineTo(200, 0);
    shapePath.relativeLineTo(100, 70);
    shapePath.relativeLineTo(-300, 0);
    shapePath.close();

    canvas.drawPath(shapePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MyDrawer extends StatefulWidget {
  final Widget drawer;
  final Widget child;
  const MyDrawer({required this.drawer, required this.child, super.key});

  @override
  State<MyDrawer> createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  late AnimationController _xControllerForChild;
  late Animation<double> _yRotationAnimationForChild;

  late AnimationController _xControllerForDrawer;
  late Animation<double> _yRotationAnimationForDrawer;

  @override
  void initState() {
    _xControllerForChild =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    _yRotationAnimationForChild =
        Tween<double>(begin: 0, end: -pi / 2).animate(_xControllerForChild);

    _xControllerForDrawer =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _yRotationAnimationForDrawer =
        Tween<double>(begin: pi / 2.7, end: 0).animate(_xControllerForDrawer);
    super.initState();
  }

  @override
  void dispose() {
    _xControllerForChild.dispose();
    _xControllerForDrawer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * .8;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final delta = details.delta.dx / maxDrag;

        _xControllerForChild.value += delta;
        _xControllerForDrawer.value += delta;
      },
      onHorizontalDragEnd: (details) {
        if (_xControllerForChild.value < 0.5) {
          _xControllerForChild.reverse();
          _xControllerForDrawer.reverse();
        } else {
          _xControllerForChild.forward();
          _xControllerForDrawer.forward();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge(
            [_yRotationAnimationForChild, _yRotationAnimationForDrawer]),
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: [
              Container(
                color: const Color(0xff1a1b26),
              ),
              Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..translate(_xControllerForChild.value * maxDrag)
                    ..rotateY(
                      _yRotationAnimationForChild.value,
                    ),
                  child: widget.child),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(
                    -screenWidth + _xControllerForDrawer.value * maxDrag,
                  )
                  ..rotateY(
                    _yRotationAnimationForDrawer.value,
                  ),
                child: widget.drawer,
              )
            ],
          );
        },
      ),
    );
  }
}
