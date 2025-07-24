import 'package:makinprrovider/core/config/appwrite_config.dart';
import 'package:makinprrovider/core/services/database_setup_service.dart';

void main() async {
  print('🧪 Testing Fixed Database Setup...\n');
  
  // Initialize Appwrite
  AppwriteConfig.initialize();
  
  try {
    // Test database setup with fixed attributes
    final success = await DatabaseSetupService.ensureCollectionsExist();
    
    if (success) {
      print('\n✅ Fixed database setup completed successfully!');
      print('Collections should now be created without default value errors.');
      print('Ready for user signup!');
    } else {
      print('\n❌ Database setup failed!');
    }
  } catch (e) {
    print('\n❌ Error during setup: $e');
  }
}
