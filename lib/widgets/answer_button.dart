import 'package:flutter/material.dart';

enum ButtonState {
  normal,
  correct,
  incorrect,
  correctAnswer,
}

class AnswerButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final ButtonState state;

  const AnswerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.state = ButtonState.normal,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
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
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        Color backgroundColor = widget.backgroundColor ?? Colors.blue.shade100;
        Color textColor = widget.textColor ?? Colors.blue.shade900;
        Color borderColor = Colors.transparent;
        double borderWidth = 2.0;

        // 根据状态设置颜色
        switch (widget.state) {
          case ButtonState.correct:
            backgroundColor = Colors.green.shade100;
            textColor = Colors.green.shade900;
            borderColor = Colors.green.shade400;
            break;
          case ButtonState.incorrect:
            backgroundColor = Colors.red.shade100;
            textColor = Colors.red.shade900;
            borderColor = Colors.red.shade400;
            break;
          case ButtonState.correctAnswer:
            backgroundColor = Colors.amber.shade100;
            textColor = Colors.amber.shade900;
            borderColor = Colors.amber.shade400;
            break;
          case ButtonState.normal:
            break;
        }

        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 主要按钮
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderColor,
                    width: borderWidth,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ElevatedButton(
                  onPressed: widget.state == ButtonState.normal ? _handlePress : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: textColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // 右上角状态图标
              if (widget.state != ButtonState.normal)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: borderColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _getStateIcon(),
                        color: _getIconColor(),
                        size: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  IconData _getStateIcon() {
    switch (widget.state) {
      case ButtonState.correct:
        return Icons.check;
      case ButtonState.incorrect:
        return Icons.close;
      case ButtonState.correctAnswer:
        return Icons.lightbulb;
      case ButtonState.normal:
        return Icons.help_outline;
    }
  }

  Color _getIconColor() {
    switch (widget.state) {
      case ButtonState.correct:
        return Colors.green.shade600;
      case ButtonState.incorrect:
        return Colors.red.shade600;
      case ButtonState.correctAnswer:
        return Colors.amber.shade600;
      case ButtonState.normal:
        return Colors.grey;
    }
  }
}