import 'dart:ui';

import 'package:flutter/material.dart';

class ActiveInfiniteCarouselCard extends StatelessWidget {
  const ActiveInfiniteCarouselCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).cardColor.withAlpha((0.6 * 255).round()),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.15 * 255).round()),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withAlpha((0.3 * 255).round()),
                    Colors.white.withAlpha((0.1 * 255).round()),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withAlpha((0.3 * 255).round()),
                  width: 0.7,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
