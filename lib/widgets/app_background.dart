import 'dart:ui';
import 'package:flutter/material.dart';

/// Shared blurred background used by every screen.
/// Shows [bg.png] with a Gaussian blur + a semi-transparent dark navy overlay
/// derived from the image's dominant colour (#0A1428).
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Raw background texture
        Image.asset('assets/bg.png', fit: BoxFit.cover),

        // Blur + dark navy overlay (colours sampled from bg.png)
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: const ColoredBox(
            color: Color(0xC80A1428), // ~78 % opaque deep navy
          ),
        ),

        // Screen content
        child,
      ],
    );
  }
}
