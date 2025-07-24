class UserModel {
  final String userId;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? passwordHash;
  final String role; // Always 'user'
  final String plan; // 'basic' or 'premium'
  final String kycStatus; // 'pending', 'verified', 'rejected'
  final bool isBlocked;
  final bool twoFactorEnabled;
  final String status; // 'pending', 'verified', 'rejected'
  final Map<String, String> kycDocuments; // For storing KYC document URLs
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.passwordHash,
    this.role = 'user',
    this.plan = 'basic',
    this.kycStatus = 'pending',
    this.isBlocked = false,
    this.twoFactorEnabled = false,
    this.status = 'pending',
    this.kycDocuments = const {},
    required this.createdAt,
    this.updatedAt,
  });

  // Check if profile is completed
  bool get isProfileCompleted {
    return phoneNumber != null && 
           phoneNumber!.isNotEmpty &&
           kycStatus != 'pending';
  }

  // Convert to Map for Appwrite
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber ?? '',
      'passwordHash': passwordHash ?? '',
      'role': role,
      'plan': plan,
      'kycStatus': kycStatus,
      'isBlocked': isBlocked,
      'twoFactorEnabled': twoFactorEnabled,
      'status': status,
      'kycDocuments': kycDocuments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from Appwrite Document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber']?.isEmpty == true ? null : map['phoneNumber'],
      passwordHash: map['passwordHash']?.isEmpty == true ? null : map['passwordHash'],
      role: map['role'] ?? 'user',
      plan: map['plan'] ?? 'basic',
      kycStatus: map['kycStatus'] ?? 'pending',
      isBlocked: map['isBlocked'] ?? false,
      twoFactorEnabled: map['twoFactorEnabled'] ?? false,
      status: map['status'] ?? 'pending',
      kycDocuments: Map<String, String>.from(map['kycDocuments'] ?? {}),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Create copy with updated fields
  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? passwordHash,
    String? role,
    String? plan,
    String? kycStatus,
    bool? isBlocked,
    bool? twoFactorEnabled,
    String? status,
    Map<String, String>? kycDocuments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      plan: plan ?? this.plan,
      kycStatus: kycStatus ?? this.kycStatus,
      isBlocked: isBlocked ?? this.isBlocked,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      status: status ?? this.status,
      kycDocuments: kycDocuments ?? this.kycDocuments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
