import 'package:flutter/material.dart';

class FeedbackAnimation extends StatefulWidget {
  final bool isCorrect;
  final VoidCallback onComplete;

  const FeedbackAnimation({
    super.key,
    required this.isCorrect,
    required this.onComplete,
  });

  @override
  State<FeedbackAnimation> createState() => _FeedbackAnimationState();
}

class _FeedbackAnimationState extends State<FeedbackAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onComplete();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: widget.isCorrect ? Colors.green : Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (widget.isCorrect ? Colors.green : Colors.red).withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Icon(
                widget.isCorrect ? Icons.check : Icons.close,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        );
      },
    );
  }
}