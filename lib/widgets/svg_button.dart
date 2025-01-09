import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SvgButtonWithText extends StatelessWidget {
  final String svgPath; // Path to the SVG asset
  final String text; // Text to display next to the SVG
  final String url; // URL to open on button press
  final double svgSize; // Size of the SVG image
  final TextStyle textStyle; // Style for the text
  final double containerWidth; // Width of the container
  final Color buttonColor;

  const SvgButtonWithText({
    super.key,
    required this.svgPath,
    required this.text,
    required this.url,
    this.svgSize = 16.0,
    this.textStyle = const TextStyle(
      fontFamily: "Audiowide",
      fontSize: 12.0,
      color: Colors.black54,
      fontWeight: FontWeight.bold,
    ),
    this.containerWidth = 165.0,
    required this.buttonColor,
  });

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        width: containerWidth,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF704214),
            width: 2.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF704214),
              offset: Offset(-5, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              width: svgSize,
              height: svgSize,
              colorFilter: const ColorFilter.mode(
                Colors.white70,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8.0), // Space between SVG and text
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
