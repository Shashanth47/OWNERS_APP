import 'package:flutter/material.dart';

class GlanceEffect extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const GlanceEffect({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<GlanceEffect> createState() => _GlanceEffectState();
}

class _GlanceEffectState extends State<GlanceEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Map the 10s duration so the sweep happens in the first 2 seconds
        // and stays silent for the remaining 8 seconds.
        double progress = _controller.value;
        double sweepPos;
        
        if (progress < 0.2) {
          // Linear sweep from -0.5 to 1.5 over the first 20% of the duration
          sweepPos = -0.5 + (progress / 0.2) * 2.0;
        } else {
          // Off-screen for the rest of the time
          sweepPos = 2.0;
        }

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                sweepPos - 0.3,
                sweepPos,
                sweepPos + 0.3,
              ],
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.12), // Slightly more subtle
                Colors.white.withOpacity(0.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
