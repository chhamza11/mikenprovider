import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class KycPendingPage extends StatefulWidget {
  const KycPendingPage({super.key});

  @override
  State<KycPendingPage> createState() => _KycPendingPageState();
}

class _KycPendingPageState extends State<KycPendingPage> {
  @override
  void initState() {
    super.initState();
    // Your navigation logic is preserved here.
    // It will navigate to the home screen after a 3-second delay.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) { // Check if the widget is still in the tree
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // A progress indicator that matches your theme's primary color
              const SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
                ),
              ),
              const SizedBox(height: 48),
              // Main title text, styled like the login screen's title
              const Text(
                'Verification Pending',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle text, styled like the login screen's subtitle
              const Text(
                'Your documents are under review. This may take a few moments.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.lightGray,
                  fontSize: 16,
                  height: 1.5, // Improves readability for multi-line text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}