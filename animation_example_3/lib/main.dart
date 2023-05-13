import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const widthAndHeight = 100.0;

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _animation;

  @override
  void initState() {
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );

    _animation = Tween<double>(begin: 0, end: pi * 2);

    super.initState();
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..forward();

    _yController
      ..reset()
      ..forward();

    _zController
      ..reset()
      ..forward();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: widthAndHeight,
            width: double.infinity,
          ),
          AnimatedBuilder(
            animation:
                Listenable.merge([_xController, _yController, _zController]),
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(_animation.evaluate(_xController))
                  ..rotateY(_animation.evaluate(_yController))
                  ..rotateZ(_animation.evaluate(_zController)),
                child: Stack(
                  children: [
                    //back widget
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..translate(Vector3(0, 0, -widthAndHeight)),
                      child: Container(
                        width: widthAndHeight,
                        height: widthAndHeight,
                        color: Colors.purple,
                      ),
                    ),

                    //left hand side

                    Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()..rotateY(pi / 2),
                      child: Container(
                        width: widthAndHeight,
                        height: widthAndHeight,
                        color: Colors.red,
                      ),
                    ),

                    // right hand side

                    Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()..rotateY(-pi / 2),
                      child: Container(
                        width: widthAndHeight,
                        height: widthAndHeight,
                        color: Colors.blue,
                      ),
                    ),

                    // front widget
                    Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.green,
                    ),

                    //top side

                    Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()..rotateX(-pi / 2),
                      child: Container(
                        width: widthAndHeight,
                        height: widthAndHeight,
                        color: Colors.orange,
                      ),
                    ),

                    // bottom side

                    Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()..rotateX(pi / 2),
                      child: Container(
                        width: widthAndHeight,
                        height: widthAndHeight,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
