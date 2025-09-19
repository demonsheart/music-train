import 'package:flutter/material.dart';
import '../models/scale_degree.dart';

class DegreeButton extends StatefulWidget {
  final ScaleDegree degree;
  final VoidCallback onPressed;

  const DegreeButton({
    super.key,
    required this.degree,
    required this.onPressed,
  });

  @override
  State<DegreeButton> createState() => _DegreeButtonState();
}

class _DegreeButtonState extends State<DegreeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ElevatedButton(
            onPressed: _handlePress,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade100,
              foregroundColor: Colors.purple.shade900,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              widget.degree.displayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}