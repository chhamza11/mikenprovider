import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart' as admin;
import 'package:dart_appwrite/enums.dart';
import '../config/appwrite_config.dart';

class DatabaseSetupService {
  // Admin client for database operations
  static admin.Client? _adminClient;
  static admin.Databases? _adminDatabases;
  
  // Admin API key - Will try to get from environment first, then fallback to hardcoded
  static const String _fallbackAdminApiKey = 'standard_1585a8ee121e5033b0d45a2ea4d71597ef5bc22c6ba708c3a9dfeaca76c965a00666accade9d55fa33b8e3b63ca77a234d3bace34e01a3747137500f2f2de062274f8f663bff77f9f3f34e788b89f5e96d51c12a22dc32d1024b8051d6c8b3551be54c0907cd900e04c386f2580033a88333899be386ea353794735180a2a8e6';
  
  static String get _adminApiKey {
    return Platform.environment['APPWRITE_API_KEY'] ?? _fallbackAdminApiKey;
  }
  
  static void _initializeAdminClient() {
    if (_adminClient == null) {
      _adminClient = admin.Client()
          .setEndpoint(AppwriteConfig.endpoint)
          .setProject(AppwriteConfig.projectId)
          .setKey(_adminApiKey);
      
      _adminDatabases = admin.Databases(_adminClient!);
    }
  }

  /// Check if collections exist and create them if they don't
  static Future<bool> ensureCollectionsExist() async {
    try {
      _initializeAdminClient();
      
      // Check if database exists
      await _ensureDatabaseExists();
      
      // Check and create collections
      await _ensureUserProviderCollectionExists();
      await _ensureMachineryCollectionExists();
      
      return true;
    } catch (e) {
      print('Error setting up database: $e');
      return false;
    }
  }

  static Future<void> _ensureDatabaseExists() async {
    try {
      await _adminDatabases!.get(databaseId: AppwriteConfig.databaseId);
      print('✅ Database already exists');
    } catch (e) {
      if (e.toString().contains('database_not_found') || 
          e.toString().contains('Database not found')) {
        print('📝 Creating database...');
        await _adminDatabases!.create(
          databaseId: AppwriteConfig.databaseId,
          name: 'makin',
        );
        print('✅ Database created successfully');
      } else {
        rethrow;
      }
    }
  }

  static Future<void> _ensureUserProviderCollectionExists() async {
    try {
      await _adminDatabases!.getCollection(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.ownersCollectionId,
      );
      print('✅ User Provider collection already exists');
    } catch (e) {
      if (e.toString().contains('collection_not_found') || 
          e.toString().contains('Collection not found')) {
        print('📝 Creating User Provider collection...');
        await _createUserProviderCollection();
        print('✅ User Provider collection created successfully');
      } else {
        rethrow;
      }
    }
  }

  static Future<void> _ensureMachineryCollectionExists() async {
    try {
      await _adminDatabases!.getCollection(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.machineryCollectionId,
      );
      print('✅ Machinery collection already exists');
    } catch (e) {
      if (e.toString().contains('collection_not_found') || 
          e.toString().contains('Collection not found')) {
        print('📝 Creating Machinery collection...');
        await _createMachineryCollection();
        print('✅ Machinery collection created successfully');
      } else {
        rethrow;
      }
    }
  }

  static Future<void> _createUserProviderCollection() async {
    const String collectionId = AppwriteConfig.ownersCollectionId;
    
    // Create the collection
    await _adminDatabases!.createCollection(
      databaseId: AppwriteConfig.databaseId,
      collectionId: collectionId,
      name: 'User Provider',
      permissions: [
        admin.Permission.read(admin.Role.any()),
        admin.Permission.create(admin.Role.users()),
        admin.Permission.update(admin.Role.users()),
        admin.Permission.delete(admin.Role.users()),
      ],
    );

    // Create attributes for OwnerModel
    final attributes = [
      {'key': 'userId', 'type': 'string', 'size': 255, 'required': true},
      {'key': 'name', 'type': 'string', 'size': 255, 'required': true},
      {'key': 'email', 'type': 'string', 'size': 320, 'required': true},
      {'key': 'phoneNumber', 'type': 'string', 'size': 20, 'required': false},
      {'key': 'passwordHash', 'type': 'string', 'size': 255, 'required': false},
{'key': 'role', 'type': 'string', 'size': 50, 'required': true},
{'key': 'plan', 'type': 'string', 'size': 50, 'required': true},
{'key': 'kycStatus', 'type': 'string', 'size': 50, 'required': true},
      {'key': 'isBlocked', 'type': 'boolean', 'required': false, 'default': false},
      {'key': 'twoFactorEnabled', 'type': 'boolean', 'required': false, 'default': false},
{'key': 'status', 'type': 'string', 'size': 50, 'required': true},
      {'key': 'kycDocuments', 'type': 'string', 'size': 1000000, 'required': false}, // JSON string
      {'key': 'createdAt', 'type': 'datetime', 'required': true},
      {'key': 'updatedAt', 'type': 'datetime', 'required': false},
    ];

    for (final attr in attributes) {
      await _createAttribute(collectionId, attr);
    }

    // Create indexes for better performance
    await _createIndexes(collectionId, [
      {'key': 'userId_index', 'attributes': ['userId']},
      {'key': 'email_index', 'attributes': ['email']},
      {'key': 'status_index', 'attributes': ['status']},
    ]);
  }

  static Future<void> _createMachineryCollection() async {
    const String collectionId = AppwriteConfig.machineryCollectionId;
    
    // Create the collection
    await _adminDatabases!.createCollection(
      databaseId: AppwriteConfig.databaseId,
      collectionId: collectionId,
      name: 'Machinery',
      permissions: [
        admin.Permission.read(admin.Role.any()),
        admin.Permission.create(admin.Role.users()),
        admin.Permission.update(admin.Role.users()),
        admin.Permission.delete(admin.Role.users()),
      ],
    );

    // Create attributes for MachineryModel
    final attributes = [
      {'key': 'listingId', 'type': 'string', 'size': 255, 'required': true},
      {'key': 'ownerId', 'type': 'string', 'size': 255, 'required': true},
      {'key': 'machineryName', 'type': 'string', 'size': 255, 'required': true},
      {'key': 'price', 'type': 'double', 'required': true},
      {'key': 'location', 'type': 'string', 'size': 255, 'required': true},
{'key': 'availabilityStatus', 'type': 'string', 'size': 50, 'required': true},
{'key': 'adminStatus', 'type': 'string', 'size': 50, 'required': true},
      {'key': 'brand', 'type': 'string', 'size': 100, 'required': true},
      {'key': 'model', 'type': 'string', 'size': 100, 'required': true},
      {'key': 'manufactureYear', 'type': 'integer', 'required': true},
      {'key': 'color', 'type': 'string', 'size': 50, 'required': true},
      {'key': 'licensePlate', 'type': 'string', 'size': 20, 'required': true},
      {'key': 'description', 'type': 'string', 'size': 2000, 'required': true},
      {'key': 'pricePerDay', 'type': 'double', 'required': true},
{'key': 'status', 'type': 'string', 'size': 50, 'required': true},
      {'key': 'createdAt', 'type': 'datetime', 'required': true},
      {'key': 'updatedAt', 'type': 'datetime', 'required': false},
    ];

    for (final attr in attributes) {
      await _createAttribute(collectionId, attr);
    }

    // Create indexes for better performance
    await _createIndexes(collectionId, [
      {'key': 'ownerId_index', 'attributes': ['ownerId']},
      {'key': 'availabilityStatus_index', 'attributes': ['availabilityStatus']},
      {'key': 'adminStatus_index', 'attributes': ['adminStatus']},
      {'key': 'status_index', 'attributes': ['status']},
    ]);
  }

  static Future<void> _createAttribute(String collectionId, Map<String, dynamic> attr) async {
    try {
      switch (attr['type']) {
        case 'string':
          await _adminDatabases!.createStringAttribute(
            databaseId: AppwriteConfig.databaseId,
            collectionId: collectionId,
            key: attr['key'],
            size: attr['size'],
            xrequired: attr['required'],
            xdefault: attr['default'],
          );
          break;
        case 'integer':
          await _adminDatabases!.createIntegerAttribute(
            databaseId: AppwriteConfig.databaseId,
            collectionId: collectionId,
            key: attr['key'],
            xrequired: attr['required'],
            xdefault: attr['default'],
          );
          break;
        case 'double':
          await _adminDatabases!.createFloatAttribute(
            databaseId: AppwriteConfig.databaseId,
            collectionId: collectionId,
            key: attr['key'],
            xrequired: attr['required'],
            xdefault: attr['default'],
          );
          break;
        case 'boolean':
          await _adminDatabases!.createBooleanAttribute(
            databaseId: AppwriteConfig.databaseId,
            collectionId: collectionId,
            key: attr['key'],
            xrequired: attr['required'],
            xdefault: attr['default'],
          );
          break;
        case 'datetime':
          await _adminDatabases!.createDatetimeAttribute(
            databaseId: AppwriteConfig.databaseId,
            collectionId: collectionId,
            key: attr['key'],
            xrequired: attr['required'],
            xdefault: attr['default'],
          );
          break;
      }
      
      print('  ✓ Created attribute: ${attr['key']} (${attr['type']})');
      
      // Wait a bit to avoid rate limiting
      await Future.delayed(Duration(milliseconds: 200));
      
    } catch (e) {
      if (e.toString().contains('already exists')) {
        print('  ✓ Attribute ${attr['key']} already exists');
      } else {
        print('  ❌ Error creating attribute ${attr['key']}: $e');
        rethrow;
      }
    }
  }

  static Future<void> _createIndexes(String collectionId, List<Map<String, dynamic>> indexes) async {
    for (final index in indexes) {
      try {
        await _adminDatabases!.createIndex(
          databaseId: AppwriteConfig.databaseId,
          collectionId: collectionId,
          key: index['key'],
          type: IndexType.key,
          attributes: List<String>.from(index['attributes']),
        );
        print('  ✓ Created index: ${index['key']}');
        
        // Wait a bit to avoid rate limiting
        await Future.delayed(Duration(milliseconds: 200));
        
      } catch (e) {
        if (e.toString().contains('already exists')) {
          print('  ✓ Index ${index['key']} already exists');
        } else {
          print('  ❌ Error creating index ${index['key']}: $e');
        }
      }
    }
  }
}
