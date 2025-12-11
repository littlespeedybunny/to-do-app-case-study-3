import 'package:flutter/material.dart';
import 'dart:ui';

/// Glowing add button with glassmorphism effect
/// Reusable widget for both Tasks and Notes tabs
class GlowingAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;
  final String? label;
  final IconData icon;

  const GlowingAddButton({
    super.key,
    required this.onPressed,
    required this.tooltip,
    this.label,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    final buttonWidget = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                isDark
                    ? colorScheme.secondary
                    : colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.9),
                blurRadius: 30,
                spreadRadius: 4,
                offset: const Offset(0, 0),
              ),
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.7),
                blurRadius: 50,
                spreadRadius: 8,
                offset: const Offset(0, 0),
              ),
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.5),
                blurRadius: 80,
                spreadRadius: 12,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: (isSmallScreen || isLandscape || label == null)
              ? FloatingActionButton(
                  onPressed: onPressed,
                  tooltip: tooltip,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Icon(icon, color: Colors.white),
                )
              : FloatingActionButton.extended(
                  onPressed: onPressed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  icon: Icon(icon, color: Colors.white),
                  label: Text(
                    label!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
      ),
    );

    return buttonWidget;
  }
}

