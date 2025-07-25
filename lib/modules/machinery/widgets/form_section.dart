import 'package:flutter/material.dart';
// Make sure this path is correct for your project
import '../../../../constants/app_colors.dart';

// The FormSection widget remains the same as it was correct.
class FormSection extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isOptional;

  const FormSection({
    super.key,
    required this.title,
    required this.child,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      margin: const EdgeInsets.only(bottom: 18.0),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: AppColors.lightGray, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// CORRECTED: This is now a class that extends InputDecoration, not an extension.
class ThemedInputDecoration extends InputDecoration {
  const ThemedInputDecoration({
    String? hintText,
    String? helperText,
    String? counterText,
    String? labelText,
  }) : super(
    hintText: hintText,
    helperText: helperText,
    counterText: counterText,
    labelText: labelText,
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFDCDCDC)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFDCDCDC)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}