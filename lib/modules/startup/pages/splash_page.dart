import 'dart:async';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
 // IMPORTANT: Adjust this import to your colors file's actual path

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait minimum 2 seconds for splash, then let AuthBloc handle navigation
    Timer(
      const Duration(seconds: 2),
      () {
        // AuthBloc listener in main app will handle navigation based on auth state
        // No need to navigate manually here
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the dark background color from your theme
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo
            Image.asset(
              'assets/logo/makinlogo.png', // Make sure this path is correct
              width: 250, // You can adjust the size as needed
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              // Use the primary orange color for the loading indicator
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
            ),
          ],
        ),
      ),
    );
  }
}