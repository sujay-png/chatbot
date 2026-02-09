import 'package:flutter/material.dart';

class FadeSlide extends StatelessWidget {
  final Widget child;
  const FadeSlide({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 450),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (_, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}