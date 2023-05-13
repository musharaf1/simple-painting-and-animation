import 'dart:math';

import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("People"),
      ),
      body: ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            final person = people[index];
            return ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DisplayScreen(person: person))),
              leading: Hero(tag: person.name, child: Image.asset(person.emoji)),
              title: Text(person.name),
              subtitle: Text("${person.age}  years old"),
            );
          }),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

@immutable
class Person {
  final int age;
  final String name;
  final String emoji;

  const Person({required this.age, required this.emoji, required this.name});
}

const people = [
  Person(age: 18, emoji: 'assets/images/emoji.png', name: "john"),
  Person(age: 19, emoji: 'assets/images/emoji.png', name: "jack"),
  Person(age: 20, emoji: 'assets/images/emoji.png', name: "jones"),
];

class DisplayScreen extends StatefulWidget {
  final Person person;
  const DisplayScreen({super.key, required this.person});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          flightShuttleBuilder: (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            switch (flightDirection) {
              case HeroFlightDirection.push:
                return Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                      scale: animation.drive(
                        Tween(begin: 0.0, end: pi).chain(
                          CurveTween(curve: Curves.fastOutSlowIn),
                        ),
                      ),
                      child: toHeroContext.widget),
                );
              case HeroFlightDirection.pop:
                return Material(
                  color: Colors.transparent,
                  child: fromHeroContext.widget,
                );
              default:
                return const Text("fire");
            }
          },
          tag: widget.person.name,
          child: Image.asset(widget.person.emoji),
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateX(_animation.value),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.amber),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.person.name,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${widget.person.age} years old",
                      style: const TextStyle(fontSize: 40),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
