import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum CircleSide { left, right }

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({required this.side});
  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

extension ToPath on CircleSide {
  Path toPath(Size size) {
    var path = Path();
    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    path.arcToPoint(offset,
        radius: Radius.elliptical(size.width / 2, size.height / 2),
        clockwise: clockwise);

    path.close();
    return path;
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;

  late AnimationController _flippedAnimationController;
  late Animation _flippedAnimation;

  @override
  void initState() {
    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );

    _counterClockwiseRotationAnimation = Tween<double>(begin: 0, end: -(pi / 2))
        .animate(CurvedAnimation(
            parent: _counterClockwiseRotationController,
            curve: Curves.bounceInOut));

    _flippedAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _flippedAnimation =
        Tween<double>(begin: 0, end: pi).animate(CurvedAnimation(
      parent: (_flippedAnimationController),
      curve: Curves.bounceInOut,
    ));

//status listener
    _counterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flippedAnimation = Tween<double>(
          begin: _flippedAnimation.value,
          end: _flippedAnimation.value + pi,
        ).animate(CurvedAnimation(
            parent: _flippedAnimationController, curve: Curves.bounceOut));

        // Reset the flip controller and start the animation

        _flippedAnimationController
          ..reset()
          ..forward();
      }
    });

    _flippedAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
                begin: _counterClockwiseRotationAnimation.value,
                end: _counterClockwiseRotationAnimation.value + -(pi / 2))
            .animate(CurvedAnimation(
                parent: _counterClockwiseRotationController,
                curve: Curves.bounceInOut));

        // Reset the flip controller and start the animation

        _counterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _flippedAnimationController.dispose();
    _counterClockwiseRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counterClockwiseRotationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _counterClockwiseRotationController,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_counterClockwiseRotationAnimation.value),
              child: Row(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _flippedAnimationController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..rotateY(_flippedAnimation.value),
                        child: ClipPath(
                          clipper:
                              const HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 122, 24, 235),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _flippedAnimationController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..rotateY(_flippedAnimation.value),
                        child: ClipPath(
                          clipper:
                              const HalfCircleClipper(side: CircleSide.right),
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 229, 232, 38),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
