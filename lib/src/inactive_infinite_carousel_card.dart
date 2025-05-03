import 'dart:ui';

import 'package:flutter/material.dart';

class InactiveInfiniteCarouselCard extends StatelessWidget {
  const InactiveInfiniteCarouselCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withAlpha((0.3 * 255).round()),
                Colors.white.withAlpha((0.1 * 255).round()),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withAlpha((0.2 * 255).round()),
              width: 0.7,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
