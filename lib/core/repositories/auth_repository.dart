import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../config/appwrite_config.dart';
import '../models/owner_model.dart';
import 'database_repository.dart';
import '../services/database_setup_service.dart';

class AuthRepository {
  final Account _account = AppwriteConfig.account;
  final DatabaseRepository _databaseRepository = DatabaseRepository();

  // Sign up with email and password
  Future<User> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Ensure database and collections exist before creating user
      print('🔄 Setting up database and collections...');
      final setupSuccess = await DatabaseSetupService.ensureCollectionsExist();
      
      if (!setupSuccess) {
        throw AuthException('Failed to set up database. Please try again.');
      }
      
      print('✅ Database setup completed');
      
      // Create user account in Appwrite Auth
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      
      // Sign in the user after creating account
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      
      print('User signed in successfully');

      // Create owner document in database
      final owner = OwnerModel(
        userId: user.$id,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      // Save owner to database
      await _databaseRepository.createOwnerDocument(owner);
      
      print('User and owner document created successfully');
      return user;
      
    } on AppwriteException catch (e) {
      throw AuthException(e.message ?? 'Sign up failed');
    } on DatabaseException catch (e) {
      throw AuthException('Database error: ${e.message}');
    } catch (e) {
      throw AuthException('Unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<Session> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      throw AuthException(e.message ?? 'Sign in failed');
    } catch (e) {
      throw AuthException('Unexpected error occurred');
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      return await _account.get();
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        return null; // User not authenticated
      }
      throw AuthException(e.message ?? 'Failed to get current user');
    } catch (e) {
      throw AuthException('Unexpected error occurred');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      throw AuthException(e.message ?? 'Sign out failed');
    } catch (e) {
      throw AuthException('Unexpected error occurred');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      await _account.get();
      return true;
    } catch (e) {
      return false;
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
