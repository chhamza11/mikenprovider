import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/auth/pages/login_page.dart';
import '../modules/home/pages/home_page.dart';
import '../core/repositories/auth_repository.dart';
import '../core/blocs/auth_bloc.dart';

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
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return HomePage(user: state.user);
              } else if (state is AuthUnauthenticated) {
                return const LoginPage();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
