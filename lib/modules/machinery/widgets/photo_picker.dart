import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class PhotoPicker extends StatelessWidget {
  const PhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildPhotoBox(isPrimary: true),
            const SizedBox(width: 16),
            _buildPhotoBox(),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Add at least 3 photos. First photo will be the main image.',
          style: TextStyle(color: AppColors.lightGray, fontSize: 12),
        )
      ],
    );
  }

  Widget _buildPhotoBox({bool isPrimary = false}) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.surface, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPrimary ? Icons.add_a_photo_outlined : Icons.add_photo_alternate_outlined,
                color: AppColors.primaryOrange, size: 32),
              const SizedBox(height: 8),
              Text(
                isPrimary ? 'Add Photo' : 'Add More',
                style: const TextStyle(color: AppColors.primaryOrange),
              )
            ],
          ),
        ),
      ),
    );
  }
}