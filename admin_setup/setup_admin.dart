import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/enums.dart';

// Your database ID
const String databaseId = '6880d58f002909acf5fa';

void main() async {
  const String endpoint = 'http://localhost/v1';
  const String projectId = '6880d52c00174ed5ab46';
  final String? apiKey = Platform.environment['APPWRITE_API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    stdout.writeln('ERROR: Please set APPWRITE_API_KEY environment variable');
    exit(1);
  }

  stdout.writeln('🚀 Starting Appwrite database setup...');

  try {
    final client = Client()
        .setEndpoint(endpoint)
        .setProject(projectId)
        .setKey(apiKey);
    final databases = Databases(client);

    await createUserProviderCollection(databases);
    await createMachineryCollection(databases);

    stdout.writeln('✅ Database setup completed successfully!');
  } catch (e) {
    stdout.writeln('❌ Error during setup: $e');
    exit(1);
  }
}

Future<void> createUserProviderCollection(Databases databases) async {
  const String collectionId = 'userprovider';
  stdout.writeln('📦 Creating userprovider collection...');

  try {
    await databases.createCollection(
      databaseId: databaseId,
      collectionId: collectionId,
      name: 'User Provider',
      permissions: [
        Permission.read(Role.any()),
        Permission.create(Role.users()),
        Permission.update(Role.user('userId')),
        Permission.delete(Role.user('userId')),
      ],
    );

    // Using a structure compatible with older SDKs
    await createAttribute(databases, collectionId, {'key': 'userId', 'type': 'string', 'size': 255, 'required': true});
    await createAttribute(databases, collectionId, {'key': 'name', 'type': 'string', 'size': 255, 'required': true});
    await createAttribute(databases, collectionId, {'key': 'phoneNumber', 'type': 'string', 'size': 20, 'required': true});
    await createAttribute(databases, collectionId, {'key': 'address', 'type': 'string', 'size': 500, 'required': true});
    await createAttribute(databases, collectionId, {'key': 'profilePicture', 'type': 'string', 'size': 500, 'required': false});
    await createAttribute(databases, collectionId, {'key': 'businessLicense', 'type': 'string', 'size': 500, 'required': false});
    await createAttribute(databases, collectionId, {'key': 'isVerified', 'type': 'boolean', 'required': true, 'default': false});

    await databases.createIndex(
      databaseId: databaseId,
      collectionId: collectionId,
      key: 'userId_index',
      type: IndexType.key,
      attributes: ['userId'],
    );
    stdout.writeln('✅ User Provider collection created successfully');
  } catch (e) {
    if (e is AppwriteException && e.message != null && e.message!.contains('already exists')) {
      stdout.writeln('ℹ️  User Provider collection or its parts already exist.');
    } else {
      rethrow;
    }
  }
}

Future<void> createMachineryCollection(Databases databases) async {
  const String collectionId = 'machinery';
  stdout.writeln('📦 Creating machinery collection...');

  try {
    await databases.createCollection(
      databaseId: databaseId,
      collectionId: collectionId,
      name: 'Machinery',
      permissions: [
        Permission.read(Role.any()),
        Permission.create(Role.users()),
        Permission.update(Role.user('ownerId')),
        Permission.delete(Role.user('ownerId')),
      ],
    );

    await createAttribute(databases, collectionId, {'key': 'ownerId', 'type': 'string', 'size': 255, 'required': true});
    await createAttribute(databases, collectionId, {'key': 'machineName', 'type': 'string', 'size': 255, 'required': true});
    await createAttribute(databases, collectionId, {'key': 'machineType', 'type': 'string', 'size': 100, 'required': true});
    await createAttribute(databases, collectionId, {'key': 'model', 'type': 'string', 'size': 255, 'required': true});
    await createAttribute(databases, collectionId, {'key': 'yearOfManufacture', 'type': 'integer', 'required': true});
    await createAttribute(databases, collectionId, {'key': 'hourlyRate', 'type': 'double', 'required': true});
    await createAttribute(databases, collectionId, {'key': 'location', 'type': 'string', 'size': 500, 'required': true});
    await createAttribute(databases, collectionId, {'key': 'description', 'type': 'string', 'size': 1000, 'required': false});
    await createAttribute(databases, collectionId, {'key': 'images', 'type': 'string', 'size': 5000, 'required': false});
    await createAttribute(databases, collectionId, {'key': 'isAvailable', 'type': 'boolean', 'required': true, 'default': true});
    await createAttribute(databases, collectionId, {'key': 'specifications', 'type': 'string', 'size': 2000, 'required': false});

    await databases.createIndex(databaseId: databaseId, collectionId: collectionId, key: 'ownerId_index', type: IndexType.key, attributes: ['ownerId']);
    await databases.createIndex(databaseId: databaseId, collectionId: collectionId, key: 'machineType_index', type: IndexType.key, attributes: ['machineType']);
    await databases.createIndex(databaseId: databaseId, collectionId: collectionId, key: 'location_index', type: IndexType.key, attributes: ['location']);

    stdout.writeln('✅ Machinery collection created successfully');
  } catch (e) {
    if (e is AppwriteException && e.message != null && e.message!.contains('already exists')) {
      stdout.writeln('ℹ️  Machinery collection or its parts already exist.');
    } else {
      rethrow;
    }
  }
}

// This function is now compatible with older SDK versions
Future<void> createAttribute(Databases databases, String collectionId, Map<String, dynamic> attr) async {
  final key = attr['key'];
  try {
    switch (attr['type']) {
      case 'string':
        await databases.createStringAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: key,
            size: attr['size'],
            xrequired: attr['required'],
            xdefault: attr['default']);
        break;
      case 'integer':
        await databases.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: key,
            xrequired: attr['required'],
            xdefault: attr['default']);
        break;
      case 'double':
        await databases.createFloatAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: key,
            xrequired: attr['required'],
            xdefault: attr['default']);
        break;
      case 'boolean':
        await databases.createBooleanAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: key,
            xrequired: attr['required'],
            xdefault: attr['default']);
        break;
    }
    stdout.writeln('  ✓ Created attribute: $key (${attr['type']})');
    await Future.delayed(const Duration(milliseconds: 200));
  } catch (e) {
    if (e is AppwriteException && e.message != null && e.message!.contains('already exists')) {
      // Ignore if it's already there
    } else {
      stdout.writeln('  ❌ Error creating attribute $key: $e');
    }
  }
}