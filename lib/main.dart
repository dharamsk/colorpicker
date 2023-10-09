import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hex Color Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ColorGame(),
    );
  }
}

class ColorGame extends StatefulWidget {
  @override
  _ColorGameState createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {
  late Color correctColor;
  late List<Color> colorOptions;
  late String hexCode;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    _generateNewColors();
  }

  Color? lastCorrectColor;

  void _generateNewColors() {
    colorOptions = List.generate(4, (index) => _randomColor());

    // Ensure the new correctColor is different from the last one
    do {
      correctColor = colorOptions[Random().nextInt(4)];
    } while (correctColor == lastCorrectColor);

    // Update lastCorrectColor for the next round
    lastCorrectColor = correctColor;

    hexCode =
        '#${correctColor.value.toRadixString(16).toUpperCase().substring(2)}';
  }

  Color _randomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  void _checkAnswer(Color selectedColor) {
    setState(() {
      isAnimating = true;
    });
    if (selectedColor == correctColor) {
      // Correct answer logic can be added here if needed
    } else {
      // Wrong answer logic can be added here if needed
    }
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isAnimating = false;
        _generateNewColors(); // Generate new set for next round
      });
    });
  }

  double _getScale(int index) {
    if (isAnimating && colorOptions[index] == correctColor) {
      return 1.2; // Increase size of the correct color during animation
    }
    return 1.0; // Default scale
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Guess the Hex Code: $hexCode")),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _checkAnswer(colorOptions[index]),
            child: Transform.scale(
              scale: _getScale(index),
              child: Container(color: colorOptions[index]),
            ),
          );
        },
        itemCount: colorOptions.length,
      ),
    );
  }
}
