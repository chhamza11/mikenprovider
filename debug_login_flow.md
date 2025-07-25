# Login Flow Analysis

## Current Flow:
1. User enters email/password in LoginPage
2. LoginCubit.login() calls AuthRepository.signIn()
3. On success, LoginCubit emits FormStatus.submissionSuccess
4. LoginForm BlocListener catches success and calls AuthBloc.add(AuthLoggedIn())
5. AuthBloc._onAuthLoggedIn() calls AuthRepository.getCurrentUser()
6. AuthBloc emits AuthAuthenticated(user)
7. ??? Navigation should happen here but appears to be missing

## Issues Identified:

### 1. No Global Navigation Listener
The main app (Makin) doesn't have a BlocListener for AuthBloc states to handle navigation. The splash screen directly navigates to LoginPage, but there's no listener to navigate away from LoginPage when authentication succeeds.

### 2. Splash Screen Issue
The SplashScreen always navigates to LoginPage after 3 seconds, regardless of authentication state. It should check AuthBloc state first.

### 3. Session Management
The "login is prohibited when session active" message suggests there might be session conflicts or multiple session creation attempts.

## Solutions Needed:
1. Add BlocListener in main app to handle AuthBloc state changes
2. Fix SplashScreen to check authentication state
3. Add proper navigation flow from LoginPage to HomePage
4. Handle session conflicts in AuthRepository
