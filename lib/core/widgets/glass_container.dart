import 'package:flutter/material.dart';
import 'dart:ui';

/// Spatial glass effect container widget
/// Creates a frosted glass effect with blur and transparency
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final double blur;
  final double opacity;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.blur = 10.0,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(20);
    final defaultBorderColor = borderColor ??
        (isDark
            ? Colors.white.withOpacity(0.2)
            : Colors.black.withOpacity(0.1));

    // Açık temada daha beyaz/parlak, koyu temada eski şeffaflık
    final effectiveOpacity = isDark
        ? opacity // Koyu temada orijinal opacity (şeffaf)
        : (opacity * 3.0).clamp(0.0, 1.0); // Açık temada daha beyaz (3x)

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: defaultBorderRadius,
        border: Border.all(
          color: defaultBorderColor,
          width: borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: defaultBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: defaultBorderRadius,
              color: isDark
                  ? Colors.white.withOpacity(effectiveOpacity)
                  : Colors.white.withOpacity(effectiveOpacity),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

