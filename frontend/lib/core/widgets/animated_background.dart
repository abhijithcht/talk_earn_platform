import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({required this.child, super.key});
  final Widget child;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FloatingEmoji> _emojis = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();

    // Generate initial emojis
    final random = math.Random();
    const icons = ['💬', '💰', '🚀', '⭐', '💎', '📱', '🔥'];

    for (var i = 0; i < 15; i++) {
      _emojis.add(
        _FloatingEmoji(
          emoji: icons[random.nextInt(icons.length)],
          startX: random.nextDouble(),
          speed: 0.5 + random.nextDouble(),
          offset: random.nextDouble(),
          size: 16 + random.nextDouble() * 24,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _EmojiPainter(emojis: _emojis, progress: _controller.value),
              child: Container(),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _FloatingEmoji {
  _FloatingEmoji({
    required this.emoji,
    required this.startX,
    required this.speed,
    required this.offset,
    required this.size,
  });
  final String emoji;
  final double startX;
  final double speed;
  final double offset;
  final double size;
}

class _EmojiPainter extends CustomPainter {
  _EmojiPainter({required this.emojis, required this.progress});
  final List<_FloatingEmoji> emojis;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final icon in emojis) {
      final currentProgress = (progress + icon.offset) % 1.0;
      final y = size.height * (1.1 - (currentProgress * 1.2));
      final x = size.width * icon.startX + (math.sin(currentProgress * math.pi * 4) * 50);

      final opacity = 0.15 * (1.0 - (currentProgress - 0.5).abs() * 2);

      final textPainter = TextPainter(
        text: TextSpan(
          text: icon.emoji,
          style: TextStyle(
            fontSize: icon.size,
            color: Colors.white.withValues(alpha: opacity.clamp(0.0, 0.15)),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(_EmojiPainter oldDelegate) => true;
}
