import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/enums.dart';

// Admin setup script for Appwrite database and collections
// This script creates the database and collections automatically
class AppwriteAdminSetup {
  // Replace these with your actual Appwrite admin credentials
  static const String endpoint = 'https://cloud.appwrite.io/v1';
  static const String projectId = '687fa2930036e6257b07';
  static const String databaseId = '6880d58f002909acf5fa';
  
  // Admin API key - REPLACE WITH YOUR ACTUAL ADMIN API KEY
  static const String adminApiKey = 'standard_1585a8ee121e5033b0d45a2ea4d71597ef5bc22c6ba708c3a9dfeaca76c965a00666accade9d55fa33b8e3b63ca77a234d3bace34e01a3747137500f2f2de062274f8f663bff77f9f3f34e788b89f5e96d51c12a22dc32d1024b8051d6c8b3551be54c0907cd900e04c386f2580033a88333899be386ea353794735180a2a8e6';
  
  late Client client;
  late Databases databases;

  void initialize() {
    client = Client()
        .setEndpoint(endpoint)
        .setProject(projectId)
        .setKey(adminApiKey); // Admin API key for server-side operations
    
    databases = Databases(client);
  }

  Future<void> setupDatabase() async {
    try {
      print('🚀 Starting Appwrite database setup...\n');
      
      // Check if database exists, if not create it
      await ensureDatabaseExists();
      
      // Create collections
      await createUserProviderCollection();
      await createMachineryCollection();
      
      print('\n✅ Database setup completed successfully!');
      print('Your Flutter app is now ready to use the database.');
      
    } catch (e) {
      print('❌ Error during setup: $e');
      exit(1);
    }
  }

  Future<void> ensureDatabaseExists() async {
    try {
      // Try to get the database
      await databases.get(databaseId: databaseId);
      print('✅ Database "$databaseId" already exists');
    } catch (e) {
      if (e.toString().contains('database_not_found')) {
        print('📝 Creating database "$databaseId"...');
        await databases.create(
          databaseId: databaseId,
          name: 'makin',
        );
        print('✅ Database created successfully');
      } else {
        rethrow;
      }
    }
  }

  Future<void> createUserProviderCollection() async {
    const String collectionId = 'userprovider';
    
    try {
      // Check if collection exists
      await databases.getCollection(databaseId: databaseId, collectionId: collectionId);
      print('✅ Collection "$collectionId" already exists');
      return;
    } catch (e) {
      if (!e.toString().contains('collection_not_found')) {
        rethrow;
      }
    }

    print('📝 Creating "$collectionId" collection...');
    
    // Create the collection
    await databases.createCollection(
      databaseId: databaseId,
      collectionId: collectionId,
      name: 'User Provider',
      permissions: [
        Permission.read(Role.any()),
        Permission.create(Role.users()),
        Permission.update(Role.users()),
        Permission.delete(Role.users()),
      ],
    );

    // Create attributes for OwnerModel
    final attributes = [
      {'key': 'userId', 'type': 'string', 'size': 255, 'required': true},
      {'key': 'name', 'type': 'string', 'size': 255, 'required': true},
      {'key': 'email', 'type': 'string', 'size': 320, 'required': true},
      {'key': 'phoneNumber', 'type': 'string', 'size': 20, 'required': false},
      {'key': 'passwordHash', 'type': 'string', 'size': 255, 'required': false},
      {'key': 'role', 'type': 'string', 'size': 50, 'required': true, 'default': 'owner'},
      {'key': 'plan', 'type': 'string', 'size': 50, 'required': true, 'default': 'basic'},
      {'key': 'kycStatus', 'type': 'string', 'size': 50, 'required': true, 'default': 'pending'},
      {'key': 'isBlocked', 'type': 'boolean', 'required': true, 'default': false},
      {'key': 'twoFactorEnabled', 'type': 'boolean', 'required': true, 'default': false},
      {'key': 'status', 'type': 'string', 'size': 50, 'required': true, 'default': 'pending'},
      {'key': 'kycDocuments', 'type': 'string', 'size': 1000000, 'required': false}, // JSON string
      {'key': 'createdAt', 'type': 'datetime', 'required': true},
      {'key': 'updatedAt', 'type': 'datetime', 'required': false},
    ];

    for (final attr in attributes) {
      await createAttribute(collectionId, attr);
    }

    // Create indexes for better performance
    await createIndexes(collectionId, [
      {'key': 'userId', 'type': 'key', 'attributes': ['userId']},
      {'key': 'email', 'type': 'key', 'attributes': ['email']},
      {'key': 'status', 'type': 'key', 'attributes': ['status']},
    ]);

    print('✅ "$collectionId" collection created successfully');
  }

  Future<void> createMachineryCollection() async {
    const String collectionId = 'machinery';
    
    try {
      // Check if collection exists
      await databases.getCollection(databaseId: databaseId, collectionId: collectionId);
      print('✅ Collection "$collectionId" already exists');
      return;
    } catch (e) {
      if (!e.toString().contains('collection_not_found')) {
        rethrow;
      }
    }

    print('📝 Creating "$collectionId" collection...');
    
    // Create the collection
    await databases.createCollection(
      databaseId: databaseId,
      collectionId: collectionId,
      name: 'Machinery',
      permissions: [
        Permission.read(Role.any()),
        Permission.create(Role.users()),
        Permission.update(Role.users()),
        Permission.delete(Role.users()),
      ],
    );

    // Create attributes for MachineryModel
    final attributes = [
      {'key': 'listingId', 'type': 'string', 'size': 255, 'required': true},
      {'key': 'ownerId', 'type': 'string', 'size': 255, 'required': true},
{'key': 'machineryName', 'type': 'string', 'size': 255, 'required': true},
      {'key': 'price', 'type': 'double', 'required': true},
      {'key': 'location', 'type': 'string', 'size': 255, 'required': true},
      {'key': 'availabilityStatus', 'type': 'string', 'size': 50, 'required': true, 'default': 'Available'},
      {'key': 'adminStatus', 'type': 'string', 'size': 50, 'required': true, 'default': 'Pending'},
      {'key': 'brand', 'type': 'string', 'size': 100, 'required': true},
      {'key': 'model', 'type': 'string', 'size': 100, 'required': true},
      {'key': 'manufactureYear', 'type': 'integer', 'required': true},
      {'key': 'color', 'type': 'string', 'size': 50, 'required': true},
      {'key': 'licensePlate', 'type': 'string', 'size': 20, 'required': true},
      {'key': 'description', 'type': 'string', 'size': 2000, 'required': true},
      {'key': 'pricePerDay', 'type': 'double', 'required': true},
      {'key': 'status', 'type': 'string', 'size': 50, 'required': true, 'default': 'Pending'},
      {'key': 'createdAt', 'type': 'datetime', 'required': true},
      {'key': 'updatedAt', 'type': 'datetime', 'required': false},
    ];

    for (final attr in attributes) {
      await createAttribute(collectionId, attr);
    }

    // Create indexes for better performance
    await createIndexes(collectionId, [
      {'key': 'ownerId', 'type': 'key', 'attributes': ['ownerId']},
      {'key': 'availabilityStatus', 'type': 'key', 'attributes': ['availabilityStatus']},
      {'key': 'adminStatus', 'type': 'key', 'attributes': ['adminStatus']},
      {'key': 'status', 'type': 'key', 'attributes': ['status']},
    ]);

    print('✅ "$collectionId" collection created successfully');
  }

  Future<void> createAttribute(String collectionId, Map<String, dynamic> attr) async {
    try {
      switch (attr['type']) {
        case 'string':
          await databases.createStringAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: attr['key'],
            size: attr['size'],
            xrequired: attr['required'],
            xdefault: attr['default'],
          );
          break;
        case 'integer':
          await databases.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: attr['key'],
            xrequired: attr['required'],
            xdefault: attr['default'],
          );
          break;
        case 'double':
          await databases.createFloatAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: attr['key'],
            xrequired: attr['required'],
            xdefault: attr['default'],
          );
          break;
        case 'boolean':
          await databases.createBooleanAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: attr['key'],
            xrequired: attr['required'],
            xdefault: attr['default'],
          );
          break;
        case 'datetime':
          await databases.createDatetimeAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: attr['key'],
            xrequired: attr['required'],
            xdefault: attr['default'],
          );
          break;
      }
      
      print('  ✓ Created attribute: ${attr['key']} (${attr['type']})');
      
      // Wait a bit to avoid rate limiting
      await Future.delayed(Duration(milliseconds: 500));
      
    } catch (e) {
      print('  ❌ Error creating attribute ${attr['key']}: $e');
    }
  }

  Future<void> createIndexes(String collectionId, List<Map<String, dynamic>> indexes) async {
    for (final index in indexes) {
      try {
        await databases.createIndex(
          databaseId: databaseId,
          collectionId: collectionId,
          key: index['key'],
          type: IndexType.key,
          attributes: List<String>.from(index['attributes']),
        );
        print('  ✓ Created index: ${index['key']}');
        
        // Wait a bit to avoid rate limiting
        await Future.delayed(Duration(milliseconds: 500));
        
      } catch (e) {
        print('  ❌ Error creating index ${index['key']}: $e');
      }
    }
  }
}

void main() async {
  print('=== Appwrite Database Setup Script ===\n');
  
  // Check if admin API key is set
  if (AppwriteAdminSetup.adminApiKey == 'YOUR_ADMIN_API_KEY_HERE') {
    print('❌ Please set your Admin API Key in the script!');
    print('   You can get it from: https://cloud.appwrite.io/console/project-${AppwriteAdminSetup.projectId}/settings');
    print('   Go to Settings > API Keys > Create API Key with full permissions');
    exit(1);
  }
  
  final setup = AppwriteAdminSetup();
  setup.initialize();
  await setup.setupDatabase();
}
