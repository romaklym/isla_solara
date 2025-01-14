import 'package:flutter/material.dart';
import 'package:islasolara/responsive/main_screen.dart';
import 'package:islasolara/responsive/mobile_screen.dart';
import 'package:islasolara/responsive/responsive_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileScreen(),
        desktopBody: MainScreen(),
      ),
    );
  }
}
