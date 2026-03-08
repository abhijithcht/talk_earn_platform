import 'package:flutter/material.dart';
import 'package:frontend/core/theme/design_constants.dart';

class RadarAnimation extends StatefulWidget {
  const RadarAnimation({
    required this.isMatching,
    super.key,
    this.statusText = 'Searching for friends...',
  });
  final bool isMatching;
  final String statusText;

  @override
  State<RadarAnimation> createState() => _RadarAnimationState();
}

class _RadarAnimationState extends State<RadarAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    if (widget.isMatching) _controller.repeat();
  }

  @override
  void didUpdateWidget(RadarAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMatching && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isMatching && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.statusText.toUpperCase(),
          style: const TextStyle(
            color: DesignConstants.accent,
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.isMatching) ...[
                _PulseAnimation(index: 0, controller: _controller),
                _PulseAnimation(index: 1, controller: _controller),
                _PulseAnimation(index: 2, controller: _controller),
              ],
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: DesignConstants.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: DesignConstants.primary.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.wifi_tethering_rounded, color: Colors.white, size: 44),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PulseAnimation extends StatelessWidget {
  const _PulseAnimation({required this.index, required this.controller});

  final int index;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = (controller.value + (index / 3)) % 1.0;
        final size = 100.0 + (progress * 220.0);
        final color = [
          DesignConstants.secondary,
          DesignConstants.primary,
          DesignConstants.accent,
        ][index % 3];

        return Opacity(
          opacity: (1.0 - progress).clamp(0.0, 1.0),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: 0),
                  color.withValues(alpha: 0.1),
                  color.withValues(alpha: 0.4),
                ],
                stops: const [0.0, 0.8, 1.0],
              ),
              border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
            ),
          ),
        );
      },
    );
  }
}
