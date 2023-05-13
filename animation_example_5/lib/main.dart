import 'package:flutter/material.dart';

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

var _defaultWidth = 200.0;

class _MyHomePageState extends State<MyHomePage> {
  var _curve = Curves.bounceOut;
  var _isZoomedIn = false;
  var _buttonTitle = "Zoom In";
  var _width = _defaultWidth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              width: _width,
              curve: _curve,
              duration: const Duration(milliseconds: 370),
              child: Image.asset('assets/images/1.png'),
            ),
          ],
        ),
        TextButton(
            onPressed: () {
              setState(() {
                _isZoomedIn = !_isZoomedIn;
                _buttonTitle = _isZoomedIn ? "Zoom out" : "Zoom In";
                _width = _isZoomedIn
                    ? MediaQuery.of(context).size.width
                    : _defaultWidth;
                _curve = _isZoomedIn ? Curves.bounceInOut : Curves.bounceOut;
              });
            },
            child: Text(
              _buttonTitle,
            ))
      ]),
    );
  }
}
