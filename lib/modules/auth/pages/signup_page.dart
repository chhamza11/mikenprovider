import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cubits/signup_cubit.dart';
import '../../../core/repositories/auth_repository.dart';
// Import your custom colors file
import '../../../constants/app_colors.dart';
import '../../../core/config/appwrite_config.dart';
import 'package:appwrite/appwrite.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) => SignupCubit(
          RepositoryProvider.of<AuthRepository>(context),
        ),
        child: const SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  void _navigateToProfileCompletion(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/profile-completion');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Sign Up Failure'),
                backgroundColor: Colors.redAccent,
              ),
            );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              // Using the specified asset logo
              Image.asset(
                'assets/logo/makinlogo.png',
                width: 200,
                height: 150,
              ),
              const SizedBox(height: 24),
              const Text(
                'Create an Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Start your journey with us today',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.lightGray,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              _NameInput(),
              const SizedBox(height: 16),
              _EmailInput(),
              const SizedBox(height: 16),
              _PasswordInput(),
              const SizedBox(height: 32),
              _SignUpButton(onProfileCompletion: () => _navigateToProfileCompletion(context)),
              const SizedBox(height: 24),
              _LoginButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          onChanged: (name) => context.read<SignupCubit>().nameChanged(name),
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Full Name',
            hintStyle: const TextStyle(color: AppColors.lightGray),
            prefixIcon: const Icon(Icons.person_outlined, color: AppColors.lightGray),
            // Corrected to use your original logic
            errorText: state.name.errorMessage,
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
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) => context.read<SignupCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: const TextStyle(color: AppColors.lightGray),
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.lightGray),
            // Corrected to use your original logic
            errorText: state.email.errorMessage,
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
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  __PasswordInputState createState() => __PasswordInputState();
}

class __PasswordInputState extends State<_PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) => context.read<SignupCubit>().passwordChanged(password),
          obscureText: _obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: const TextStyle(color: AppColors.lightGray),
            helperText: 'Password must be at least 8 characters.',
            helperStyle: const TextStyle(color: AppColors.mediumGray),
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.lightGray),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.lightGray,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
            // Corrected to use your original logic
            errorText: state.password.errorMessage,
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
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final VoidCallback onProfileCompletion;
  const _SignUpButton({required this.onProfileCompletion});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: state.status.isValidated
              ? () => context.read<SignupCubit>().signUp(onProfileCompletion)
              : null,
          child: state.status.isSubmissionInProgress
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: RichText(
        text: const TextSpan(
          text: "Already have an account? ",
          style: TextStyle(color: AppColors.lightGray, fontSize: 14),
          children: <TextSpan>[
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



