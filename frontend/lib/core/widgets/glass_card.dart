import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:frontend/core/theme/design_constants.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.blur = DesignConstants.glassBlur,
  });
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? const BorderRadius.all(DesignConstants.glassRadius);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(boxShadow: [DesignConstants.glassShadow]),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: DesignConstants.glassBg,
              borderRadius: effectiveRadius,
              border: Border.all(
                color: DesignConstants.glassBorder,
                width: DesignConstants.glassBorderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
