import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart' as admin;
import 'package:dart_appwrite/enums.dart';

void main() async {
  const String endpoint = 'https://cloud.appwrite.io/v1';
  const String projectId = '687fa2930036e6257b07';
  const String databaseId = '6880d58f002909acf5fa';
  const String collectionId = 'userprovider';
  
  // Admin API key - you can replace this with your actual API key
  const String adminApiKey = 'standard_1585a8ee121e5033b0d45a2ea4d71597ef5bc22c6ba708c3a9dfeaca76c965a00666accade9d55fa33b8e3b63ca77a234d3bace34e01a3747137500f2f2de062274f8f663bff77f9f3f34e788b89f5e96d51c12a22dc32d1024b8051d6c8b3551be54c0907cd900e04c386f2580033a88333899be386ea353794735180a2a8e6';
  
  print('🚀 Starting collection schema fix...');
  
  try {
    final client = admin.Client()
        .setEndpoint(endpoint)
        .setProject(projectId)
        .setKey(adminApiKey);
    
    final databases = admin.Databases(client);
    
    // Delete the existing collection
    print('🗑️ Deleting existing collection...');
    try {
      await databases.deleteCollection(
        databaseId: databaseId,
        collectionId: collectionId,
      );
      print('✅ Collection deleted successfully');
    } catch (e) {
      print('⚠️ Collection might not exist: $e');
    }
    
    // Wait a moment
    await Future.delayed(Duration(seconds: 2));
    
    // Create the collection with correct schema
    print('📦 Creating collection with correct schema...');
    await databases.createCollection(
      databaseId: databaseId,
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
      {'key': 'kycDocuments', 'type': 'string', 'size': 1000000, 'required': false},
      {'key': 'createdAt', 'type': 'datetime', 'required': true},
      {'key': 'updatedAt', 'type': 'datetime', 'required': false},
    ];
    
    for (final attr in attributes) {
      await createAttribute(databases, databaseId, collectionId, attr);
    }
    
    // Create indexes
    await createIndex(databases, databaseId, collectionId, 'userId_index', ['userId']);
    await createIndex(databases, databaseId, collectionId, 'email_index', ['email']);
    await createIndex(databases, databaseId, collectionId, 'status_index', ['status']);
    
    print('✅ Collection schema fixed successfully!');
    
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}

Future<void> createAttribute(admin.Databases databases, String databaseId, String collectionId, Map<String, dynamic> attr) async {
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
    await Future.delayed(Duration(milliseconds: 300));
    
  } catch (e) {
    if (e.toString().contains('already exists')) {
      print('  ✓ Attribute ${attr['key']} already exists');
    } else {
      print('  ❌ Error creating attribute ${attr['key']}: $e');
      rethrow;
    }
  }
}

Future<void> createIndex(admin.Databases databases, String databaseId, String collectionId, String key, List<String> attributes) async {
  try {
    await databases.createIndex(
      databaseId: databaseId,
      collectionId: collectionId,
      key: key,
      type: IndexType.key,
      attributes: attributes,
    );
    print('  ✓ Created index: $key');
    await Future.delayed(Duration(milliseconds: 300));
  } catch (e) {
    if (e.toString().contains('already exists')) {
      print('  ✓ Index $key already exists');
    } else {
      print('  ❌ Error creating index $key: $e');
    }
  }
}
