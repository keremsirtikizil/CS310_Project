// lib/routes/loadingOverlay.dart
import 'package:flutter/material.dart';

// This LoadingOverlay doesn't navigate anywhere - it just shows and dismisses itself
class LoadingOverlay extends StatefulWidget {
  final int durationInMilliseconds;
  final String? navigateTo;
  final bool removeUntil;
  final bool Function(Route<dynamic>)? predicate;

  const LoadingOverlay({
    Key? key,
    this.durationInMilliseconds = 1000,
    this.navigateTo,
    this.removeUntil = false,
    this.predicate,
  }) : super(key: key);

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Dismiss and navigate after the specified duration
    Future.delayed(Duration(milliseconds: widget.durationInMilliseconds), () {
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss overlay

        // Handle navigation if a route was provided
        if (widget.navigateTo != null) {
          if (widget.removeUntil) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              widget.navigateTo!,
              widget.predicate ?? (route) => false,
            );
          } else {
            Navigator.of(context).pushNamed(widget.navigateTo!);
          }
        }
      }
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F1DC), // Cream/beige color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom indeterminate loader
              SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  painter: GroceryLoaderPainter(animation: _controller),
                ),
              ),
              const SizedBox(height: 40),
              // Loading text
              const Text(
                'Loading',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for the loader (same as before)
class GroceryLoaderPainter extends CustomPainter {
  final Animation<double> animation;

  GroceryLoaderPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background track (light gray circle)
    final trackPaint = Paint()
      ..color = const Color(0xFFDFE1E5) // Light gray color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Animated green progress arc
    final progressPaint = Paint()
      ..color = const Color(0xFF0F6632) // Dark green color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    // Calculate start and sweep angles for the animated arc
    const startAngle = -0.5 * 3.14159; // -90 degrees (top position)
    final sweepAngle = 0.3 * 3.14159 * 2; // Partial circle (about 60 degrees or 1/6 of the circle)

    // Rotate the arc based on animation value
    final rotationAngle = animation.value * 2 * 3.14159; // Full 360 rotation

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + rotationAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant GroceryLoaderPainter oldDelegate) {
    return true;
  }
}

// Update the function to accept navigation parameters
Future<void> showLoadingTransition(
    BuildContext context, {
      int durationMs = 1000,
      String? navigateTo,
      bool removeUntil = false,
      bool Function(Route<dynamic>)? predicate,
    }) async {
  // Show loading overlay
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return LoadingOverlay(
        durationInMilliseconds: durationMs,
        // Pass navigation info to the LoadingOverlay
        navigateTo: navigateTo,
        removeUntil: removeUntil,
        predicate: predicate,
      );
    },
  );
}