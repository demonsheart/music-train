import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteButton extends StatefulWidget {
  final NoteName note;
  final VoidCallback onPressed;

  const NoteButton({
    super.key,
    required this.note,
    required this.onPressed,
  });

  @override
  State<NoteButton> createState() => _NoteButtonState();
}

class _NoteButtonState extends State<NoteButton> with SingleTickerProviderStateMixin {
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
              backgroundColor: Colors.blue.shade100,
              foregroundColor: Colors.blue.shade900,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              widget.note.displayName,
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