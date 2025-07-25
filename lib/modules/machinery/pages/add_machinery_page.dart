import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../widgets/form_section.dart';
import '../widgets/photo_picker.dart';
import '../widgets/location_picker.dart';
import '../widgets/availability_calendar.dart';

class AddMachineryPage extends StatefulWidget {
  const AddMachineryPage({super.key});

  @override
  State<AddMachineryPage> createState() => _AddMachineryPageState();
}

class _AddMachineryPageState extends State<AddMachineryPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();
  final _hoursController = TextEditingController();
  final _yearController = TextEditingController();
  String? _selectedCategory;
  String? _selectedRentalUnit = 'per Hour';
  String? _selectedMinRental = '1 hour';
  bool _insurance = false;
  bool _operator = false;

  final List<String> _categories = [
    'Excavator', 'Bulldozer', 'Crane', 'Loader', 'Other'
  ];
  final List<String> _rentalUnits = ['per Hour', 'per Day', 'per Week'];
  final List<String> _minRentals = ['1 hour', '4 hours', '1 day', '1 week'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Add Machinery', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormSection(
              title: 'Machinery Title *',
              child: _customTextField(_titleController, 'e.g., Caterpillar 320D Excavator'),
            ),
            FormSection(
              title: 'Description *',
              child: _customTextField(_descController, 'Describe the machinery condition, features, and specifications...', maxLines: 4, minLines: 3),
            ),
            FormSection(
              title: 'Category *',
              child: _customDropdown(_selectedCategory, _categories, (val) => setState(() => _selectedCategory = val)),
            ),
            FormSection(
              title: 'Rental Price *',
              child: Row(
                children: [
                  Expanded(child: _customTextField(_priceController, '0.00', keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: _customDropdown(_selectedRentalUnit, _rentalUnits, (val) => setState(() => _selectedRentalUnit = val))),
                ],
              ),
            ),
            FormSection(
              title: 'Minimum Rental & Security Deposit',
              child: Row(
                children: [
                  Expanded(child: _customDropdown(_selectedMinRental, _minRentals, (val) => setState(() => _selectedMinRental = val))),
                  const SizedBox(width: 12),
                  Expanded(child: _customTextField(_depositController, '0.00', keyboardType: TextInputType.number)),
                ],
              ),
            ),
            const FormSection(
              title: 'Photos *',
              child: PhotoPicker(),
            ),
            const FormSection(
              title: 'Location *',
              child: LocationPicker(),
            ),
            const FormSection(
              title: 'Availability Calendar',
              child: AvailabilityCalendar(),
            ),
            FormSection
              (
              title: 'Additional Details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _customTextField(_hoursController, 'e.g., 500 hours'),
                  const SizedBox(height: 12),
                  _customTextField(_yearController, '2020'),
                  Row(
                    children: [
                      Checkbox(
                        value: _insurance,
                        onChanged: (val) => setState(() => _insurance = val ?? false),
                        activeColor: AppColors.primaryOrange,
                      ),
                      const Text('Insurance included', style: TextStyle(color: AppColors.lightGray)),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _operator,
                        onChanged: (val) => setState(() => _operator = val ?? false),
                        activeColor: AppColors.primaryOrange,
                      ),
                      const Text('Operator available', style: TextStyle(color: AppColors.lightGray)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Submit Listing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text('Review all details before submitting', style: TextStyle(color: AppColors.mediumGray)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _customTextField(TextEditingController controller, String hint, {int maxLines = 1, int? minLines, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.lightGray),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.surface, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.surface, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
        ),
      ),
    );
  }

  Widget _customDropdown(String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surface, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.surface,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryOrange),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(color: Colors.white)),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}