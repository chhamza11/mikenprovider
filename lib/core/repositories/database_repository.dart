import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../config/appwrite_config.dart';
import '../models/owner_model.dart';
import '../models/machinery_model.dart';

class DatabaseRepository {
  final Databases _databases = AppwriteConfig.databases;
  
  static const String _databaseId = AppwriteConfig.databaseId;
  static const String _ownersCollectionId = AppwriteConfig.ownersCollectionId;
  static const String _machineryCollectionId = AppwriteConfig.machineryCollectionId;

  // === OWNER OPERATIONS ===

  // Create owner document
  Future<OwnerModel> createOwnerDocument(OwnerModel owner) async {
    try {
      print('Creating owner document...');
      
      final data = owner.toMap();
      
      final document = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _ownersCollectionId,
        documentId: ID.unique(),
        data: data,
      );

      print('Owner document created successfully');
      return _documentToOwnerModel(document);
    } catch (e) {
      print('Error creating owner document: $e');
      
      // Check if it's a database/collection not found error
      if (e.toString().contains('database_not_found') || 
          e.toString().contains('collection_not_found') ||
          e.toString().contains('Database not found') ||
          e.toString().contains('Collection not found')) {
        throw DatabaseException('Database or collection not found. The database setup may have failed.');
      }
      
      // Re-throw other errors
      if (e is AppwriteException) {
        throw DatabaseException(e.message ?? 'Failed to create owner document');
      }
      
      throw DatabaseException('Unexpected error: ${e.toString()}');
    }
  }

  // Get owner by userId
  Future<OwnerModel?> getOwnerByUserId(String userId) async {
    try {
      final documents = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _ownersCollectionId,
        queries: [
          Query.equal('userId', userId),
        ],
      );

      if (documents.documents.isEmpty) {
        return null;
      }

      return _documentToOwnerModel(documents.documents.first);
    } catch (e) {
      print('Error getting owner: $e');
      return null;
    }
  }

  // Update owner document
  Future<OwnerModel> updateOwnerDocument(String documentId, OwnerModel owner) async {
    try {
      final data = owner.copyWith(updatedAt: DateTime.now()).toMap();

      final document = await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _ownersCollectionId,
        documentId: documentId,
        data: data,
      );

      return _documentToOwnerModel(document);
    } catch (e) {
      print('Error updating owner document: $e');
      return owner;
    }
  }

  // === MACHINERY OPERATIONS ===

  // Create machinery document
  Future<MachineryModel> createMachineryDocument(MachineryModel machinery) async {
    try {
      final data = machinery.toMap();
      
      final document = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _machineryCollectionId,
        documentId: ID.unique(),
        data: data,
      );

      return _documentToMachineryModel(document);
    } catch (e) {
      print('Error creating machinery document: $e');
      return machinery;
    }
  }

  // Get machinery by owner ID
  Future<List<MachineryModel>> getMachineryByOwnerId(String ownerId) async {
    try {
      final documents = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _machineryCollectionId,
        queries: [
          Query.equal('ownerId', ownerId),
        ],
      );

      return documents.documents
          .map((doc) => _documentToMachineryModel(doc))
          .toList();
    } catch (e) {
      print('Error getting machinery: $e');
      return [];
    }
  }

  // Get all machinery (for user app to see)
  Future<List<MachineryModel>> getAllMachinery() async {
    try {
      final documents = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _machineryCollectionId,
      );

      return documents.documents
          .map((doc) => _documentToMachineryModel(doc))
          .toList();
    } catch (e) {
      print('Error getting all machinery: $e');
      return [];
    }
  }

  // === HELPER METHODS ===

  // Convert Appwrite Document to OwnerModel
  OwnerModel _documentToOwnerModel(Document document) {
    final data = document.data;
    
    Map<String, String> kycDocs = {};
    try {
      if (data['kycDocuments'] != null && data['kycDocuments'].isNotEmpty) {
        kycDocs = Map<String, String>.from(data['kycDocuments'] ?? {});
      }
    } catch (e) {
      kycDocs = {};
    }

    return OwnerModel(
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber']?.isEmpty == true ? null : data['phoneNumber'],
      passwordHash: data['passwordHash']?.isEmpty == true ? null : data['passwordHash'],
      role: data['role'] ?? 'owner',
      plan: data['plan'] ?? 'basic',
      kycStatus: data['kycStatus'] ?? 'pending',
      isBlocked: data['isBlocked'] ?? false,
      twoFactorEnabled: data['twoFactorEnabled'] ?? false,
      status: data['status'] ?? 'pending',
      kycDocuments: kycDocs,
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  // Convert Appwrite Document to MachineryModel
  MachineryModel _documentToMachineryModel(Document document) {
    final data = document.data;

    return MachineryModel(
      listingId: data['listingId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      machineryName: data['machineryName'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      location: data['location'] ?? '',
      availabilityStatus: data['availabilityStatus'] ?? 'Available',
      adminStatus: data['adminStatus'] ?? 'Pending',
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      manufactureYear: data['manufactureYear'] ?? DateTime.now().year,
      color: data['color'] ?? '',
      licensePlate: data['licensePlate'] ?? '',
      description: data['description'] ?? '',
      pricePerDay: (data['pricePerDay'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'Pending',
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}
