import 'package:flutter/material.dart';

/// Widget that displays the game background with smooth transitions
class BackgroundLayer extends StatelessWidget {
  final String backgroundImage;

  const BackgroundLayer({
    super.key,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Container(
        key: ValueKey(backgroundImage),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
