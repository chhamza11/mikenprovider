import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appwrite/models.dart';
import '../../../core/blocs/auth_bloc.dart';
import '../../../core/repositories/database_repository.dart';
import '../../../core/models/owner_model.dart';
import '../../../core/models/machinery_model.dart';
import '../../../constants/app_colors.dart'; // Import your custom colors

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  OwnerModel? _ownerData;
  List<MachineryModel> _machineryList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOwnerData();
  }

  Future<void> _loadOwnerData() async {
    // This logic remains unchanged
    try {
      final owner = await _databaseRepository.getOwnerByUserId(widget.user.$id);
      final machinery = await _databaseRepository.getMachineryByOwnerId(widget.user.$id);

      if (mounted) {
        setState(() {
          _ownerData = owner;
          _machineryList = machinery;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading owner data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Provider Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadOwnerData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange))
          : RefreshIndicator(
        onRefresh: _loadOwnerData,
        color: AppColors.primaryOrange,
        backgroundColor: AppColors.surface,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              _buildSectionContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hello, ${widget.user.name}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.email,
                      style: const TextStyle(color: AppColors.lightGray, fontSize: 14),
                    ),
                    if (_ownerData != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: (_ownerData!.status == 'pending' ? AppColors.primaryOrange : Colors.green).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Status: ${_ownerData!.status.toUpperCase()}',
                          style: TextStyle(
                            color: _ownerData!.status == 'pending' ? AppColors.primaryOrange : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Owner Information Card
              if (_ownerData != null)
                _buildSectionContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Provider Information',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(color: AppColors.mediumGray, height: 24),
                      _InfoRow('User ID:', _ownerData!.userId),
                      _InfoRow('Email:', _ownerData!.email),
                      _InfoRow('Name:', _ownerData!.name),
                      _InfoRow('Phone:', _ownerData!.phoneNumber ?? 'Not provided'),
                      _InfoRow('Role:', _ownerData!.role),
                      _InfoRow('Plan:', _ownerData!.plan),
                      _InfoRow('KYC Status:', _ownerData!.kycStatus),
                      _InfoRow('Account Status:', _ownerData!.status),
                      _InfoRow('Profile Complete:', _ownerData!.isProfileCompleted ? 'Yes' : 'No'),
                      _InfoRow('Created:', _formatDate(_ownerData!.createdAt.toIso8601String())),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Machinery Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Machinery (${_machineryList.length})',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddMachineryDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Machine'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Machinery List
              if (_machineryList.isEmpty)
                _buildEmptyState()
              else
                ..._machineryList.map((machinery) => _buildMachineryCard(machinery)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildEmptyState() {
    return _buildSectionContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.precision_manufacturing_outlined,
                size: 64,
                color: AppColors.mediumGray,
              ),
              const SizedBox(height: 16),
              const Text(
                'No machinery listed yet',
                style: TextStyle(color: AppColors.lightGray, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first machine to start earning!',
                style: TextStyle(color: AppColors.mediumGray, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _InfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.lightGray),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildMachineryCard(MachineryModel machinery) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  machinery.machineryName,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (machinery.adminStatus == 'Approved'
                      ? Colors.green
                      : machinery.adminStatus == 'Rejected'
                      ? Colors.red
                      : AppColors.primaryOrange).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  machinery.adminStatus,
                  style: TextStyle(
                    color: machinery.adminStatus == 'Approved'
                        ? Colors.greenAccent[400]
                        : machinery.adminStatus == 'Rejected'
                        ? Colors.redAccent[100]
                        : AppColors.primaryOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.mediumGray, height: 24),
          _InfoRow('Brand:', machinery.brand),
          _InfoRow('Location:', machinery.location),
          _InfoRow('Price/Day:', '₹${machinery.pricePerDay}'),
          _InfoRow('Status:', machinery.availabilityStatus),
          if (machinery.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Description:',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              machinery.description,
              style: const TextStyle(color: AppColors.lightGray),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddMachineryDialog() {
    // This logic remains unchanged
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Add New Machine', style: TextStyle(color: Colors.white)),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Machine listing form will be implemented here.',
                  style: TextStyle(fontSize: 16, color: AppColors.lightGray),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.lightGray)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Machine listing feature is coming soon!'),
                    backgroundColor: AppColors.primaryOrange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryOrange),
              child: const Text('Coming Soon', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    // This logic remains unchanged
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: const Text('Are you sure you want to logout?', style: TextStyle(color: AppColors.lightGray)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.lightGray)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthLoggedOut());
              },
              child: const Text('Logout', style: TextStyle(color: AppColors.primaryOrange)),
            ),
          ],
        );
      },
    );
  }
}