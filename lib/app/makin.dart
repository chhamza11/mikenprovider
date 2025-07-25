import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/auth/pages/login_page.dart';
import '../modules/auth/pages/signup_page.dart';
import '../modules/home/pages/home_page.dart';
import '../core/repositories/auth_repository.dart';
import '../core/blocs/auth_bloc.dart';
import '../../modules/startup/pages/splash_page.dart';
import '../modules/providerkyc/KycPendingPage.dart';
import '../modules/providerkyc/ProfileCompletionPage.dart';

class Makin extends StatelessWidget {
  const Makin({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(RepositoryProvider.of<AuthRepository>(context))..add(AuthStarted()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: {
            '/signup': (context) => const SignupPage(),
            '/profile-completion': (context) => const ProfileCompletionPage(),
            '/kyc-pending': (context) => const KycPendingPage(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return HomePage(user: state.user);
                } else {
                  return const LoginPage();
                }
              },
            ),
          },
          home: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home',
                  (route) => false,
                );
              } else if (state is AuthUnauthenticated) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
