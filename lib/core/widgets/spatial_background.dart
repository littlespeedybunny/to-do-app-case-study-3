import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Spatial background with animated elements
/// Light theme: Sun and clouds with bright light effects
/// Dark theme: Neon effects and glowing particles
class SpatialBackground extends StatefulWidget {
  final Widget child;

  const SpatialBackground({super.key, required this.child});

  @override
  State<SpatialBackground> createState() => _SpatialBackgroundState();
}

class _SpatialBackgroundState extends State<SpatialBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Animated background
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _SpatialPainter(
                isDark: isDark,
                colorScheme: colorScheme,
                animationValue: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class _SpatialPainter extends CustomPainter {
  final bool isDark;
  final ColorScheme colorScheme;
  final double animationValue;

  _SpatialPainter({
    required this.isDark,
    required this.colorScheme,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isDark) {
      _paintDarkTheme(canvas, size);
    } else {
      _paintLightTheme(canvas, size);
    }
  }

  void _paintLightTheme(Canvas canvas, Size size) {
    // Gradient background - bright sky
    const skyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFE3F2FD),
        Color(0xFFF5F7FA),
        Color(0xFFFFF9E6),
      ],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = skyGradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        ),
    );

    // Animated sun
    final sunX = size.width * 0.8;
    final sunY =
        size.height * 0.15 + math.sin(animationValue * 2 * math.pi) * 20;
    const sunRadius = 80.0;

    // Sun glow
    final sunGlow = Paint()
      ..color = const Color(0xFFFFF8DC).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(
      Offset(sunX, sunY),
      sunRadius + 30,
      sunGlow,
    );

    // Sun
    final sunPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFFFF8DC),
          Color(0xFFFFD700),
        ],
      ).createShader(
        Rect.fromCircle(center: Offset(sunX, sunY), radius: sunRadius),
      );
    canvas.drawCircle(Offset(sunX, sunY), sunRadius, sunPaint);

    // Clouds
    _drawCloud(canvas, size.width * 0.2, size.height * 0.2, 0.8);
    _drawCloud(canvas, size.width * 0.6, size.height * 0.3, 0.6);
    _drawCloud(canvas, size.width * 0.4, size.height * 0.5, 0.7);
  }

  void _drawCloud(Canvas canvas, double x, double y, double scale) {
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final radius = 30.0 * scale;
    canvas.drawCircle(Offset(x, y), radius, cloudPaint);
    canvas.drawCircle(Offset(x + radius * 0.8, y), radius * 0.9, cloudPaint);
    canvas.drawCircle(Offset(x - radius * 0.8, y), radius * 0.9, cloudPaint);
    canvas.drawCircle(Offset(x, y - radius * 0.5), radius * 0.8, cloudPaint);
  }

  void _paintDarkTheme(Canvas canvas, Size size) {
    // Dark gradient background
    const darkGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0A0E27),
        Color(0xFF1A1F3A),
        Color(0xFF0F1419),
      ],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = darkGradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        ),
    );

    // Neon particles and effects
    const particleCount = 50;
    for (int i = 0; i < particleCount; i++) {
      final angle =
          (i / particleCount) * 2 * math.pi + animationValue * 2 * math.pi;
      final radius = size.width * 0.3;
      final x = size.width / 2 + math.cos(angle) * radius;
      final y = size.height / 2 + math.sin(angle) * radius;

      final colors = [
        colorScheme.primary,
        colorScheme.secondary,
        colorScheme.tertiary,
      ];
      final color = colors[i % colors.length];

      final particlePaint = Paint()
        ..color = color.withOpacity(0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(
        Offset(x, y),
        3 + math.sin(animationValue * 2 * math.pi + i) * 2,
        particlePaint,
      );
    }

    // Neon glow effects
    final glowPaint = Paint()
      ..color = colorScheme.primary.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      100,
      glowPaint,
    );

    final glowPaint2 = Paint()
      ..color = colorScheme.secondary.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      120,
      glowPaint2,
    );
  }

  @override
  bool shouldRepaint(_SpatialPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isDark != isDark;
  }
}
