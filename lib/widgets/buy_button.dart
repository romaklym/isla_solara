import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuyButton extends StatefulWidget {
  final VoidCallback onTap; // Pass a custom function for onTap
  final double iconSize;
  final double fontSize;
  final double sizedBoxSize;

  const BuyButton({
    super.key,
    required this.onTap, // Require onTap function
    this.iconSize = 20.0, // Default icon size
    this.fontSize = 18.0, // Default font size
    this.sizedBoxSize = 28.0, // Default spacing size
  });

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  double _hoverGlow = 0.0; // Glow intensity on hover
  bool _isPressed = false; // Tracks if the button is being clicked

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverGlow = 1.0),
      onExit: (_) => setState(() => _hoverGlow = 0.0),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: _hoverGlow),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          builder: (context, glowValue, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2ab7e3)
                        .withValues(alpha: 0.5 * glowValue),
                    blurRadius: 20 * glowValue,
                    spreadRadius: 8 * glowValue,
                  ),
                  BoxShadow(
                    color: const Color(0xFF704214),
                    offset: const Offset(-5, 5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: AnimatedScale(
                scale: _isPressed ? 0.95 : 1.0, // Scale down when pressed
                duration: const Duration(milliseconds: 100),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.sizedBoxSize, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2ab7e3),
                        const Color(0xFF45ebea),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    border: Border.all(
                      color: Colors.black54,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.dollarSign,
                        color: Colors.white70,
                        size: widget.iconSize,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        "Buy",
                        style: TextStyle(
                          fontFamily: "Audiowide",
                          fontSize: widget.fontSize,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
