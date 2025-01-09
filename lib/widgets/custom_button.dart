import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final String? label; // Optional label
  final IconData? icon; // Optional icon
  final String? svgPath; // Optional SVG path
  final VoidCallback? onTap;
  final String? windowKey; // Optional parameter
  final Map<String, bool>? windowVisibility; // Optional parameter
  final double fontSize;
  final double iconSize;
  final int? maxCharacters; // Optional maximum characters for label

  const CustomButton({
    super.key,
    required this.color,
    this.label, // Label is now optional
    this.icon, // Icon is now optional
    this.svgPath, // SVG path is optional
    required this.onTap,
    this.windowKey,
    this.windowVisibility,
    this.fontSize = 12.0,
    this.iconSize = 16.0, // Default size for icons
    this.maxCharacters, // Max characters for label is optional
  }) : assert(label != null || icon != null || svgPath != null,
            'Either label, icon, svgPath, or all can be omitted, but at least one is recommended.');

  @override
  Widget build(BuildContext context) {
    // Determine button color based on visibility or fallback to default
    final buttonColor = (windowVisibility != null &&
            windowKey != null &&
            windowVisibility![windowKey] == true)
        ? color // Active color
        : color; // Default inactive color

    // Truncate the label if maxCharacters is provided
    final truncatedLabel = (label != null && maxCharacters != null)
        ? (label!.length > maxCharacters!
            ? '${label!.substring(0, (maxCharacters! ~/ 2) - 1)}...${label!.substring(label!.length - ((maxCharacters! ~/ 2) - 1))}'
            : label)
        : label;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF704214), // Shadow color
            offset: const Offset(-5, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: buttonColor, // Use determined button color
            border: Border.all(color: Colors.black54, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display SVG if provided
              if (svgPath != null)
                SvgPicture.asset(
                  svgPath!,
                  width: iconSize,
                  height: iconSize,
                  colorFilter: const ColorFilter.mode(
                    Colors.white70,
                    BlendMode.srcIn,
                  ),
                ),
              // Otherwise display the icon if provided
              if (svgPath == null && icon != null)
                Icon(
                  icon,
                  color: Colors.white70,
                  size: iconSize,
                ),
              // Add spacing if there is both an icon/svg and a label
              if ((svgPath != null || icon != null) && truncatedLabel != null)
                const SizedBox(
                  width: 8.0,
                ),
              // Display the truncated label if provided
              if (truncatedLabel != null)
                Text(
                  truncatedLabel,
                  style: TextStyle(
                    fontFamily: "Audiowide",
                    fontSize: fontSize,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
