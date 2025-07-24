class MachineryModel {
  final String listingId;
  final String ownerId;
  final String machineryName;
  final double price;
  final String location;
  final String availabilityStatus; // 'Available', 'Rented'
  final String adminStatus; // 'Pending', 'Approved', 'Rejected'
  final String brand;
  final String model;
  final int manufactureYear;
  final String color;
  final String licensePlate;
  final String description;
  final double pricePerDay;
  final String status; // 'Pending', 'Approved', 'Rejected'
  final DateTime createdAt;
  final DateTime? updatedAt;

  MachineryModel({
    required this.listingId,
    required this.ownerId,
    required this.machineryName,
    required this.price,
    required this.location,
    this.availabilityStatus = 'Available',
    this.adminStatus = 'Pending',
    required this.brand,
    required this.model,
    required this.manufactureYear,
    required this.color,
    required this.licensePlate,
    required this.description,
    required this.pricePerDay,
    this.status = 'Pending',
    required this.createdAt,
    this.updatedAt,
  });

  // Check if machinery is available for rent
  bool get isAvailable {
    return availabilityStatus == 'Available' && 
           adminStatus == 'Approved' && 
           status == 'Approved';
  }

  // Convert to Map for Appwrite
  Map<String, dynamic> toMap() {
    return {
      'listingId': listingId,
      'ownerId': ownerId,
      'machineryName': machineryName,
      'price': price,
      'location': location,
      'availabilityStatus': availabilityStatus.isNotEmpty ? availabilityStatus : 'Available',
      'adminStatus': adminStatus.isNotEmpty ? adminStatus : 'Pending',
      'brand': brand,
      'model': model,
      'manufactureYear': manufactureYear,
      'color': color,
      'licensePlate': licensePlate,
      'description': description,
      'pricePerDay': pricePerDay,
      'status': status.isNotEmpty ? status : 'Pending',
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from Appwrite Document
  factory MachineryModel.fromMap(Map<String, dynamic> map) {
    return MachineryModel(
      listingId: map['listingId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      machineryName: map['machineryName'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      location: map['location'] ?? '',
      availabilityStatus: map['availabilityStatus'] ?? 'Available',
      adminStatus: map['adminStatus'] ?? 'Pending',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      manufactureYear: map['manufactureYear'] ?? DateTime.now().year,
      color: map['color'] ?? '',
      licensePlate: map['licensePlate'] ?? '',
      description: map['description'] ?? '',
      pricePerDay: (map['pricePerDay'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'Pending',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Create copy with updated fields
  MachineryModel copyWith({
    String? listingId,
    String? ownerId,
    String? machineryName,
    double? price,
    String? location,
    String? availabilityStatus,
    String? adminStatus,
    String? brand,
    String? model,
    int? manufactureYear,
    String? color,
    String? licensePlate,
    String? description,
    double? pricePerDay,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MachineryModel(
      listingId: listingId ?? this.listingId,
      ownerId: ownerId ?? this.ownerId,
      machineryName: machineryName ?? this.machineryName,
      price: price ?? this.price,
      location: location ?? this.location,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      adminStatus: adminStatus ?? this.adminStatus,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      manufactureYear: manufactureYear ?? this.manufactureYear,
      color: color ?? this.color,
      licensePlate: licensePlate ?? this.licensePlate,
      description: description ?? this.description,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
