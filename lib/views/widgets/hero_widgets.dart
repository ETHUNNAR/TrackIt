import 'package:flutter/material.dart';

class HeroWidgets extends StatelessWidget {
  const HeroWidgets({
    super.key,
    required this.title,
    this.nextPage,
  });

  final String title;
  final Widget? nextPage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          nextPage != null
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return nextPage!;
                    },
                  ),
                );
              }
              : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: 'hero1',
            child: AspectRatio(
              aspectRatio: 1920 / 1080,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                  color: Colors.teal,
                  colorBlendMode:
                      BlendMode.darken,
                ),
              ),
            ),
          ),
          FittedBox(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 50,
                letterSpacing: 50,
                color: Colors.white60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
