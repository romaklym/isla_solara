import 'package:flutter/material.dart';
import 'package:taxhavistan/screens/globe_widget.dart';
import 'package:taxhavistan/widgets/app_bar.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:taxhavistan/widgets/footer.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Interactive Globe
          Center(
            child: GlobeWidget(
              zoomIn: 12.5,
            ),
          ),
          CustomAppBar(),
          Footer(),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  icon: Icons.map_rounded,
                  color: const Color(0xFF269b4b),
                  label: "View Map",
                  onTap: () {
                    context.go('/map');
                  },
                  fontSize: 16.0,
                  iconSize: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
