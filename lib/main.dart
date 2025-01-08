import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxhavistan/home_page.dart';
import 'package:taxhavistan/screens/map_screen.dart';

void main() {
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
            // Extracting values from extra
            final Map<String, dynamic> args =
                state.extra as Map<String, dynamic>;
            final String publicKey = args['publicKey'];
            final double tokenBalance = args['tokenBalance'];

            return MapScreen(
              publicKey: publicKey,
              tokenBalance: tokenBalance,
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
