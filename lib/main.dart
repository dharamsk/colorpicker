import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Picker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ColorGame(),
    );
  }
}

final defaultTextStyle = GoogleFonts.sourceCodePro(
  color: Colors.black,
  shadows: [
    const Shadow(offset: Offset(-1, -1), color: Colors.white),
    const Shadow(offset: Offset(1, -1), color: Colors.white),
    const Shadow(offset: Offset(1, 1), color: Colors.white),
    const Shadow(offset: Offset(-1, 1), color: Colors.white),
  ],
);

class ColorGame extends StatefulWidget {
  const ColorGame({super.key});

  @override
  _ColorGameState createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {
  late Color correctColor;
  late List<Color> colorOptions;
  late String hexCode;
  late ConfettiController _confettiController;
  bool isAnimating = false;
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    _generateNewColors();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Color? lastCorrectColor;

  void _generateNewColors() {
    colorOptions = List.generate(4, (index) => _randomColor());

    do {
      correctColor = colorOptions[Random().nextInt(4)];
    } while (correctColor == lastCorrectColor);

    lastCorrectColor = correctColor;

    hexCode =
        '#${correctColor.value.toRadixString(16).toUpperCase().substring(2)}';
  }

  Color _randomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  void _checkAnswer(Color selectedColor) {
    if (isAnswered) return;

    setState(() {
      isAnimating = true;
      isAnswered = true;
    });

    if (selectedColor == correctColor) {
      _confettiController.play(); // Play confetti animation
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isAnimating = false;
      });
    });
  }

  double _getScale(int index) {
    if (isAnimating && colorOptions[index] == correctColor) {
      return 1.2;
    }
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick the color: $hexCode",
            style: GoogleFonts.sourceCodePro()),
        actions: [
          IconButton(
            icon: Icon(Icons.party_mode),
            onPressed: () {
              print('AppBar button pressed. Playing confetti.');
              _confettiController.play();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _colorTile(0),
                    _colorTile(1),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    _colorTile(2),
                    _colorTile(3),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              hexCode,
              style: defaultTextStyle.copyWith(fontSize: 60),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            // blastDirection: pi, // radial value - LEFT
            // particleDrag: 0.05, // apply drag to the confetti
            // emissionFrequency: 0.05, // how often it should emit
            // numberOfParticles: 20, // number of particles to emit
            // gravity: 0.05, // gravity - or fall speed
            // shouldLoop:
            //     false, // start again as soon as the animation is finished
            // colors: const [
            //   // manually specify the colors to be used
            //   Colors.green,
            //   Colors.blue,
            //   Colors.pink,
            //   Colors.orange,
            //   Colors.purple
            // ],
          ),
        ],
      ),
    );
  }

  Widget _colorTile(int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isAnswered) {
            setState(() {
              _generateNewColors();
              isAnswered = false;
            });
          } else {
            _checkAnswer(colorOptions[index]);
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: _getScale(index),
              child: Container(color: colorOptions[index]),
            ),
            if (isAnswered)
              Text(
                '#${colorOptions[index].value.toRadixString(16).toUpperCase().substring(2)}',
                style: defaultTextStyle.copyWith(fontSize: 36),
              ),
          ],
        ),
      ),
    );
  }
}
