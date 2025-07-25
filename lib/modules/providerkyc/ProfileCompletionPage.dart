import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../core/config/appwrite_config.dart';
import 'package:appwrite/appwrite.dart';



class ProfileCompletionPage extends StatefulWidget {
  const ProfileCompletionPage({super.key});

  @override
  State<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  final _phoneController = TextEditingController();
  File? _profileImage;
  File? _cnicImage;
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _pickImage(bool isProfile) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isProfile) {
          _profileImage = File(picked.path);
        } else {
          _cnicImage = File(picked.path);
        }
      });
    }
  }

  Future<String?> _uploadFile(File file, String fileName) async {
    try {
      final storage = Storage(AppwriteConfig.client);
      final result = await storage.createFile(
        bucketId: '6883209500240458c4b4', // Make sure this bucket exists in Appwrite
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path, filename: fileName),
      );
      // Return the file URL
      return result.$id;
    } catch (e) {
      setState(() { _errorMessage = 'File upload failed: $e'; });
      return null;
    }
  }

  Future<void> _submitProfile() async {
    setState(() { _isSubmitting = true; _errorMessage = null; });
    try {
      final phone = _phoneController.text.trim();
      if (phone.isEmpty || _profileImage == null || _cnicImage == null) {
        setState(() {
          _errorMessage = 'Please fill all fields and upload both images.';
          _isSubmitting = false;
        });
        return;
      }
      // Upload images
      final profilePicId = await _uploadFile(_profileImage!, 'profile_picture.jpg');
      final cnicPicId = await _uploadFile(_cnicImage!, 'cnic_picture.jpg');
      if (profilePicId == null || cnicPicId == null) {
        setState(() { _isSubmitting = false; });
        return;
      }
      // Update user document
      final user = await AppwriteConfig.account.get();
      final databases = AppwriteConfig.databases;
      final userDoc = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.ownersCollectionId,
        queries: [
          Query.equal('userId', user.$id),
        ],
      );
      if (userDoc.documents.isEmpty) {
        setState(() { _errorMessage = 'User document not found.'; _isSubmitting = false; });
        return;
      }
      final docId = userDoc.documents.first.$id;
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.ownersCollectionId,
        documentId: docId,
        data: {
          'phoneNumber': phone,
          'profilePicture': profilePicId,
          'kycDocuments': '{"cnicPicture": "$cnicPicId"}',
          'kycStatus': 'pending',
        },
      );
      // Navigate to KYC Pending
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/kyc-pending');
      }
    } catch (e) {
      setState(() { _errorMessage = 'Profile update failed: $e'; });
    } finally {
      setState(() { _isSubmitting = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Icon(Icons.account_circle, size: 80, color: AppColors.primaryOrange),
              const SizedBox(height: 24),
              Text(
                'Profile Completion',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please provide your phone number and upload required documents',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.lightGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: const TextStyle(color: AppColors.lightGray),
                  prefixIcon: const Icon(Icons.phone, color: AppColors.lightGray),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryOrange),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _ImagePickerButton(
                label: 'Upload Profile Picture',
                file: _profileImage,
                onPick: () => _pickImage(true),
              ),
              const SizedBox(height: 16),
              _ImagePickerButton(
                label: 'Upload CNIC Picture',
                file: _cnicImage,
                onPick: () => _pickImage(false),
              ),
              const SizedBox(height: 32),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isSubmitting ? null : _submitProfile,
                child: _isSubmitting
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePickerButton extends StatelessWidget {
  final String label;
  final File? file;
  final VoidCallback onPick;
  const _ImagePickerButton({required this.label, required this.file, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.upload_file, color: AppColors.primaryOrange),
          label: Text(label, style: const TextStyle(color: AppColors.primaryOrange)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primaryOrange),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPick,
        ),
        if (file != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('File selected: ${file!.path.split('/').last}', style: const TextStyle(color: AppColors.lightGray)),
          ),
      ],
    );
  }
}