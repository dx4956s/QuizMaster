import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum OptionState { normal, correct, wrong, dimmed }

class OptionButton extends StatelessWidget {
  final String text;
  final int index; // 0-3 for A-D label
  final OptionState state;
  final VoidCallback? onPressed;

  const OptionButton({
    Key? key,
    required this.text,
    required this.index,
    required this.state,
    required this.onPressed,
  }) : super(key: key);

  static const _labels = ['A', 'B', 'C', 'D'];

  Color _bgColor(ColorScheme cs) {
    switch (state) {
      case OptionState.correct:
        return const Color(0xFF1B5E20);
      case OptionState.wrong:
        return const Color(0xFF7F0000);
      case OptionState.dimmed:
        return cs.surfaceContainerHighest;
      case OptionState.normal:
        return cs.primaryContainer;
    }
  }

  Color _labelBgColor(ColorScheme cs) {
    switch (state) {
      case OptionState.correct:
        return const Color(0xFF2E7D32);
      case OptionState.wrong:
        return const Color(0xFFC62828);
      case OptionState.dimmed:
        return cs.outline;
      case OptionState.normal:
        return cs.primary;
    }
  }

  Color _textColor(ColorScheme cs) {
    switch (state) {
      case OptionState.correct:
      case OptionState.wrong:
        return Colors.white;
      case OptionState.dimmed:
        return cs.onSurfaceVariant;
      case OptionState.normal:
        return cs.onPrimaryContainer;
    }
  }

  IconData? get _trailingIcon {
    switch (state) {
      case OptionState.correct:
        return Icons.check_circle_rounded;
      case OptionState.wrong:
        return Icons.cancel_rounded;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final icon = _trailingIcon;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _bgColor(cs),
          borderRadius: BorderRadius.circular(14),
          boxShadow: state == OptionState.normal
              ? [
                  BoxShadow(
                    color: cs.primary.withOpacity(0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  // Letter label
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _labelBgColor(cs),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _labels[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Option text
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _textColor(cs),
                      ),
                    ),
                  ),
                  // Trailing icon
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 22,
                    ).animate().scale(
                          begin: const Offset(0, 0),
                          duration: 300.ms,
                          curve: Curves.elasticOut,
                        ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
