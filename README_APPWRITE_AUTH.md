# Flutter Appwrite Authentication App

This Flutter application implements user authentication using Appwrite as the backend service and Bloc Cubit for state management.

## Project Structure

```
lib/
├── app/
│   └── makin.dart                    # Main app widget with routing logic
├── core/
│   ├── blocs/
│   │   └── auth_bloc.dart            # Authentication state management
│   ├── config/
│   │   └── appwrite_config.dart      # Appwrite configuration
│   ├── cubits/
│   │   ├── login_cubit.dart          # Login form state management
│   │   └── signup_cubit.dart         # Signup form state management
│   ├── enums/
│   │   └── form_status.dart          # Custom form status enum
│   ├── extensions/
│   │   └── formz_extensions.dart     # Form validation extensions
│   ├── models/
│   │   ├── email.dart                # Email validation model
│   │   ├── name.dart                 # Name validation model
│   │   └── password.dart             # Password validation model
│   └── repositories/
│       └── auth_repository.dart      # Authentication repository
├── modules/
│   ├── auth/
│   │   └── pages/
│   │       ├── login_page.dart       # Login UI
│   │       └── signup_page.dart      # Signup UI
│   └── home/
│       └── pages/
│           └── home_page.dart        # Home page for authenticated users
└── main.dart                         # App entry point
```

## Features

### ✅ Implemented Features

1. **Authentication System**
   - User registration with email, password, and name
   - User login with email and password
   - Authentication state management
   - Automatic redirect based on authentication status

2. **Form Validation**
   - Real-time email validation with regex
   - Password validation (minimum 8 characters)
   - Name validation (minimum 2 characters)
   - Form status tracking (pure, valid, invalid, submitting, success, failure)

3. **State Management**
   - Bloc Cubit pattern for form management
   - Bloc pattern for authentication state
   - Repository pattern for data layer

4. **UI/UX**
   - Material Design 3
   - Loading indicators during authentication
   - Error handling with snackbars
   - Responsive design

## Appwrite Configuration

### Current Configuration
- **Project ID**: `687fa2930036e6257b07`
- **Endpoint**: `https://cloud.appwrite.io/v1`
- **Database ID**: `main_database` (configured but not used yet)
- **Users Collection ID**: `users` (configured but not used yet)

### Required Appwrite Setup

1. **Create an Appwrite Project** (if not already done)
   - Visit [Appwrite Console](https://cloud.appwrite.io/)
   - Create a new project with ID: `687fa2930036e6257b07`

2. **Configure Authentication**
   - Enable Email/Password authentication in your Appwrite console
   - Set up your authentication settings

3. **Web Platform Setup**
   - Add a web platform in your Appwrite console
   - Set the hostname to `localhost` for development

## Running the Application

### Prerequisites
- Flutter SDK (version 3.6.0 or higher)
- Web browser (Chrome recommended)

### Installation
1. Navigate to the project directory
2. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App
```bash
flutter run -d chrome  # For web
flutter run -d windows # For Windows desktop
```

## Usage

### Registration Flow
1. Open the app - you'll see the login page
2. Click "Sign Up" to navigate to registration
3. Fill in your name, email, and password
4. Click "Create Account"
5. If successful, you'll be redirected back to login
6. Sign in with your new credentials

### Login Flow
1. Enter your email and password
2. Click "Login"
3. If successful, you'll be redirected to the home page

### Home Page
- Displays user information
- Shows user details like ID, email, name, verification status
- Provides logout functionality

## Key Features Explained

### Form Validation
- **Email**: Validates using regex pattern for proper email format
- **Password**: Must be at least 8 characters long
- **Name**: Must be at least 2 characters long
- Real-time validation feedback with error messages

### Authentication States
- **Initial**: App is starting up
- **Loading**: Checking authentication status
- **Authenticated**: User is logged in
- **Unauthenticated**: User needs to log in

### Error Handling
- Network errors are caught and displayed to users
- Form validation errors are shown inline
- Authentication errors show as snackbars

## Customization

### Updating Appwrite Configuration
Edit `lib/core/config/appwrite_config.dart`:
```dart
class AppwriteConfig {
  static const String endpoint = 'YOUR_APPWRITE_ENDPOINT';
  static const String projectId = 'YOUR_PROJECT_ID';
  // ... other configurations
}
```

### Styling
The app uses Material Design 3 with a deep purple color scheme. You can customize the theme in `lib/app/makin.dart`.

### Adding More Validation Rules
You can extend the validation models in `lib/core/models/` to add more complex validation rules.

## Dependencies Used

- **appwrite**: ^12.0.3 - Appwrite Flutter SDK
- **flutter_bloc**: ^8.1.3 - State management
- **formz**: ^0.6.1 - Form validation
- **flutter_secure_storage**: ^9.0.0 - Secure storage (configured but not used)
- **go_router**: ^14.1.4 - Routing (added but not implemented)

## Next Steps

### Recommended Enhancements
1. **Email Verification**: Implement email verification flow
2. **Password Reset**: Add forgot password functionality
3. **User Profile**: Create user profile management
4. **Persistent Login**: Use secure storage to remember login state
5. **Better Error Handling**: More specific error messages
6. **Loading States**: Better loading indicators
7. **Offline Support**: Handle offline scenarios

### Security Considerations
1. Always use HTTPS in production
2. Implement proper session management
3. Add rate limiting for authentication attempts
4. Consider implementing 2FA for enhanced security

## Troubleshooting

### Common Issues
1. **CORS Errors**: Ensure your domain is added in Appwrite console
2. **Authentication Failures**: Check Appwrite project configuration
3. **Form Not Submitting**: Ensure all validation passes

### Debug Mode
The app includes extensive error handling. Check the console for detailed error messages during development.

## Contributing

When adding new features:
1. Follow the existing project structure
2. Use Bloc Cubit for form state management
3. Add proper error handling
4. Include validation for user inputs
5. Update this README with new features
