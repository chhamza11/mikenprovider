import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class LocationPicker extends StatelessWidget {
  const LocationPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter address or drag pin on map',
            filled: true,
            fillColor: AppColors.surface,
            hintStyle: const TextStyle(color: AppColors.lightGray),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.surface, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.surface, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.surface, width: 1.5),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.location_pin, color: AppColors.primaryOrange, size: 32),
                SizedBox(width: 8),
                Text('Tap to set location', style: TextStyle(color: AppColors.lightGray)),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: false,
              onChanged: (value) {},
              activeColor: AppColors.primaryOrange,
            ),
            const Text('Offer delivery service', style: TextStyle(color: AppColors.lightGray)),
          ],
        ),
      ],
    );
  }
}