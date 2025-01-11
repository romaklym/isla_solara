import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomButton extends StatefulWidget {
  final Color color;
  final String? label;
  final IconData? icon;
  final String? svgPath;
  final VoidCallback? onTap;
  final String? windowKey;
  final Map<String, bool>? windowVisibility;
  final double fontSize;
  final double iconSize;
  final int? maxCharacters;

  const CustomButton({
    super.key,
    required this.color,
    this.label,
    this.icon,
    this.svgPath,
    required this.onTap,
    this.windowKey,
    this.windowVisibility,
    this.fontSize = 12.0,
    this.iconSize = 16.0,
    this.maxCharacters,
  }) : assert(label != null || icon != null || svgPath != null,
            'Either label, icon, svgPath, or all can be omitted, but at least one is recommended.');

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double _hoverGlow = 0.0; // Glow intensity on hover
  bool _isPressed = false; // Tracks if the button is being clicked

  @override
  Widget build(BuildContext context) {
    // Determine button color based on visibility or fallback to default
    final buttonColor = (widget.windowVisibility != null &&
            widget.windowKey != null &&
            widget.windowVisibility![widget.windowKey] == true)
        ? widget.color
        : widget.color;

    // Truncate the label if maxCharacters is provided
    final truncatedLabel = (widget.label != null &&
            widget.maxCharacters != null &&
            widget.maxCharacters! > 0)
        ? (widget.label!.length > widget.maxCharacters!
            ? '${widget.label!.substring(0, (widget.maxCharacters! ~/ 2) - 1)}...${widget.label!.substring(widget.label!.length - ((widget.maxCharacters! ~/ 2) - 1))}'
            : widget.label)
        : widget.label;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoverGlow = 1.0),
      onExit: (_) => setState(() => _hoverGlow = 0.0),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() {
          _isPressed = false;
          widget.onTap?.call();
        }),
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
                    color: widget.color.withValues(alpha: 0.4 * glowValue),
                    blurRadius: 15 * glowValue,
                    spreadRadius: 5 * glowValue,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    border: Border.all(color: Colors.black54, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display SVG if provided
                      if (widget.svgPath != null)
                        SvgPicture.asset(
                          widget.svgPath!,
                          width: widget.iconSize,
                          height: widget.iconSize,
                          colorFilter: const ColorFilter.mode(
                            Colors.white70,
                            BlendMode.srcIn,
                          ),
                        ),
                      // Otherwise display the icon if provided
                      if (widget.svgPath == null && widget.icon != null)
                        FaIcon(
                          widget.icon,
                          color: Colors.white70,
                          size: widget.iconSize,
                        ),
                      // Add spacing if there is both an icon/svg and a label
                      if ((widget.svgPath != null || widget.icon != null) &&
                          truncatedLabel != null)
                        const SizedBox(
                          width: 8.0,
                        ),
                      // Display the truncated label if provided
                      if (truncatedLabel != null)
                        Text(
                          truncatedLabel,
                          style: TextStyle(
                            fontFamily: "Audiowide",
                            fontSize: widget.fontSize,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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
