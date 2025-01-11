import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxhavistan/home_page.dart';
import 'package:taxhavistan/responsive/mobile_screen.dart';
import 'package:taxhavistan/responsive/responsive_layout.dart';
import 'package:taxhavistan/screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
        apiKey: "AIzaSyAHHPBGEbeRFhu4qP-jw7X1rkikassN9-Q",
        authDomain: "taxhavistan.firebaseapp.com",
        databaseURL: "https://taxhavistan-default-rtdb.firebaseio.com",
        projectId: "taxhavistan",
        storageBucket: "taxhavistan.firebasestorage.app",
        messagingSenderId: "176859126239",
        appId: "1:176859126239:web:61b7b60d9be9892d0a8c6a"),
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) {
            return ResponsiveLayout(
              mobileBody: MobileScreen(),
              desktopBody: MapScreen(),
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF42A5F5),
                Color(0xFF1E88E5)
              ], // Blue gradient colors
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: child, // Apply the gradient to the entire app
        );
      },
    );
  }
}
