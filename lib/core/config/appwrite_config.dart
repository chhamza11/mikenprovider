import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';

class AppwriteConfig {
  static const String endpoint = 'https://cloud.appwrite.io/v1';
  static const String projectId = '687fa2930036e6257b07';
  static const String databaseId = '6880d58f002909acf5fa'; // Updated to use existing database
  static const String usersCollectionId = 'users';
  static const String ownersCollectionId = 'userprovider';
  static const String machineryCollectionId = 'machinery';

  static late Client client;
  static late Account account;
  static late Databases databases;
  
  static bool _initialized = false;

  static void initialize() {
    if (_initialized) return;
    
    try {
      client = Client()
          .setEndpoint(endpoint)
          .setProject(projectId);
      
      // Only set self-signed for development and debug mode
      if (kDebugMode) {
        client.setSelfSigned(status: true);
      }
      
      account = Account(client);
      databases = Databases(client);
      
      _initialized = true;
      
      if (kDebugMode) {
        print('Appwrite initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Appwrite: $e');
      }
      rethrow;
    }
  }
}
