import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(
    MaterialApp(
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

class _MyHomePageState extends State<MyHomePage> {
  var _color = getRandomColor();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ClipPath(
          clipper: const CustomOvalPath(),
          child: TweenAnimationBuilder(
            duration: const Duration(seconds: 1),
            tween: ColorTween(begin: getRandomColor(), end: _color),
            builder: (BuildContext context, Color? color, Widget? child) {
              return ColorFiltered(
                  colorFilter: ColorFilter.mode(color!, BlendMode.srcATop),
                  child: child!);
            },
            onEnd: () => setState(() {
              _color = getRandomColor();
            }),
            child: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

Color getRandomColor() {
  return Color(0xFF000000 + math.Random().nextInt(0x00FFFFFF));
}

class CustomOvalPath extends CustomClipper<Path> {
  const CustomOvalPath();
  @override
  Path getClip(Size size) {
    final path = Path();

    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);

    path.addOval(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
