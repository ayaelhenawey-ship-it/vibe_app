import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _ringDrawingAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeIn)),
    );

    _ringDrawingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.easeInOutQuart)),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/auth_wrapper');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFC9A96E).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: AnimatedBuilder(
                    animation: _ringDrawingAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(200, 200),
                        painter: VibeLogoPainter(
                          ringProgress: _ringDrawingAnimation.value,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                FadeTransition(
                  opacity: _textAnimation,
                  child: Column(
                    children: [
                      const Text(
                        'VIBE',
                        style: TextStyle(
                          color: Color(0xFFC9A96E),
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 10,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'YOUR SOCIAL SPACE',
                        style: TextStyle(
                          color: const Color(0xFFC9A96E).withValues(alpha: 0.45), // تم استبدال withOpacity
                          fontSize: 12,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VibeLogoPainter extends CustomPainter {
  final double ringProgress;
  VibeLogoPainter({required this.ringProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final goldGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE8D5A3), Color(0xFFC9A96E), Color(0xFFA07840)],
    ).createShader(rect);

    final vPaint = Paint()
      ..shader = goldGradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final ringPaint = Paint()
      ..shader = goldGradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // 1. رسم حرف الـ V (إحداثيات الـ SVG المظبوطة)
    final vPath = Path()
      ..moveTo(52, 42)
      ..lineTo(100, 138)
      ..lineTo(148, 42);
    canvas.drawPath(vPath, vPaint);

    // 2. رسم الشرطة العرضية
    canvas.drawLine(
      const Offset(68, 72),
      const Offset(132, 72),
      vPaint..strokeWidth = 14,
    );

    // 3. رسم الحلقة بأنيميشن (Drawing)
    final ringPath = Path()
      ..addOval(Rect.fromCenter(center: const Offset(100, 100), width: 156, height: 44));

    for (final pathMetric in ringPath.computeMetrics()) {
      final extractPath = pathMetric.extractPath(0.0, pathMetric.length * ringProgress);
      canvas.drawPath(extractPath, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant VibeLogoPainter oldDelegate) => 
      oldDelegate.ringProgress != ringProgress;
}