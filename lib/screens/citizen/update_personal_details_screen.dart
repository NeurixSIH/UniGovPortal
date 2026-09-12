import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/demo_repository.dart';

class UpdatePersonalDetailsScreen extends StatefulWidget {
  final VoidCallback onSaved;
  final VoidCallback onCancel;

  const UpdatePersonalDetailsScreen({
    super.key,
    required this.onSaved,
    required this.onCancel,
  });

  @override
  State<UpdatePersonalDetailsScreen> createState() => _UpdatePersonalDetailsScreenState();
}

class _UpdatePersonalDetailsScreenState extends State<UpdatePersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final DemoRepository _repo = DemoRepository();

  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;

  String _gender = 'Female';
  String _incomeBracket = '₹1,50,000 - ₹3,00,000';
  String _category = 'General';
  String _landOwnership = '2.5 Acres (Agricultural)';

  @override
  void initState() {
    super.initState();
    final user = _repo.citizenUser;
    _nameController = TextEditingController(text: user.fullName);
    _mobileController = TextEditingController(text: user.mobileNumber);
    _dobController = TextEditingController(text: '14/05/1996');
    _addressController = TextEditingController(text: user.address['line1'] ?? 'Flat 402, Shivam Apts, Shivaji Nagar');
    _cityController = TextEditingController(text: user.city);
    _stateController = TextEditingController(text: user.state);
    _pincodeController = TextEditingController(text: user.pincode);

    _gender = user.gender;
    _incomeBracket = user.incomeBracket.isNotEmpty ? user.incomeBracket : '₹1,50,000 - ₹3,00,000';
    _category = user.category.isNotEmpty ? user.category : 'General';
    _landOwnership = user.landOwnership;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _repo.updateCitizenDetails(
        fullName: _nameController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        addressLine: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        incomeBracket: _incomeBracket,
        landOwnership: _landOwnership,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.sync, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text('Changes saved & synchronized with connected departments!'),
              ),
            ],
          ),
          backgroundColor: AppTheme.statusSuccess,
          duration: const Duration(seconds: 3),
        ),
      );

      widget.onSaved();
    }
  }

  void _reviewChangesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.rate_review_outlined, color: AppTheme.primaryBlue),
              SizedBox(width: 8),
              Text('Review Changes', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogRow('Full Name', _nameController.text),
                _dialogRow('Mobile Number', _mobileController.text),
                _dialogRow('Address', '${_addressController.text}, ${_cityController.text}'),
                _dialogRow('Pincode', _pincodeController.text),
                _dialogRow('Land Ownership', _landOwnership),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlueLight.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Upon confirmation, these updates will dispatch real-time sync events to Municipal Corporation and Revenue Department.',
                    style: TextStyle(fontSize: 11, color: AppTheme.primaryBlue),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Edit'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _saveChanges();
              },
              child: const Text('Confirm & Sync'),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text('$label:', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: widget.onCancel,
        ),
        title: const Text('Update Personal Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interoperability Notice Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlueLight.withAlpha(20),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.primaryBlue.withAlpha(60)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Updating your information may synchronize approved fields with connected departments automatically.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryBlueDark,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Form fields card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Full Name', isRequired: true),
                    TextFormField(
                      controller: _nameController,
                      validator: (v) => v == null || v.isEmpty ? 'Full name is required' : null,
                      decoration: const InputDecoration(hintText: 'Enter full name'),
                    ),

                    const SizedBox(height: 14),

                    _fieldLabel('Mobile Number', isRequired: true),
                    TextFormField(
                      controller: _mobileController,
                      validator: (v) => v == null || v.isEmpty ? 'Mobile number is required' : null,
                      decoration: const InputDecoration(hintText: 'Enter mobile number'),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('Date of Birth', isRequired: true),
                              TextFormField(
                                controller: _dobController,
                                decoration: const InputDecoration(
                                  hintText: 'DD/MM/YYYY',
                                  suffixIcon: Icon(Icons.calendar_today, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('Gender', isRequired: true),
                              DropdownButtonFormField<String>(
                                initialValue: _gender,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                                ],
                                onChanged: (v) => setState(() => _gender = v ?? 'Female'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _fieldLabel('Address Line', isRequired: true),
                    TextFormField(
                      controller: _addressController,
                      validator: (v) => v == null || v.isEmpty ? 'Address is required' : null,
                      decoration: const InputDecoration(hintText: 'House no, Building, Street'),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('City', isRequired: true),
                              TextFormField(
                                controller: _cityController,
                                validator: (v) => v == null || v.isEmpty ? 'City is required' : null,
                                decoration: const InputDecoration(hintText: 'City'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('State', isRequired: true),
                              TextFormField(
                                controller: _stateController,
                                decoration: const InputDecoration(hintText: 'State'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _fieldLabel('Pincode', isRequired: true),
                    TextFormField(
                      controller: _pincodeController,
                      validator: (v) => v == null || v.isEmpty ? 'Pincode is required' : null,
                      decoration: const InputDecoration(hintText: '6-digit pincode'),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 14),

                    _fieldLabel('Income Bracket', isRequired: false),
                    DropdownButtonFormField<String>(
                      initialValue: _incomeBracket,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'Below ₹1,00,000', child: Text('Below ₹1,00,000')),
                        DropdownMenuItem(value: '₹1,50,000 - ₹3,00,000', child: Text('₹1,50,000 - ₹3,00,000')),
                        DropdownMenuItem(value: '₹3,00,000 - ₹8,00,000', child: Text('₹3,00,000 - ₹8,00,000')),
                        DropdownMenuItem(value: 'Above ₹8,00,000', child: Text('Above ₹8,00,000')),
                      ],
                      onChanged: (v) => setState(() => _incomeBracket = v ?? _incomeBracket),
                    ),

                    const SizedBox(height: 14),

                    _fieldLabel('Category', isRequired: false),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'General', child: Text('General')),
                        DropdownMenuItem(value: 'OBC', child: Text('OBC')),
                        DropdownMenuItem(value: 'SC', child: Text('SC')),
                        DropdownMenuItem(value: 'ST', child: Text('ST')),
                        DropdownMenuItem(value: 'EWS', child: Text('EWS')),
                      ],
                      onChanged: (v) => setState(() => _category = v ?? 'General'),
                    ),

                    const SizedBox(height: 14),

                    _fieldLabel('Land Ownership', isRequired: false),
                    DropdownButtonFormField<String>(
                      initialValue: _landOwnership,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'None', child: Text('None (No Agricultural Land)')),
                        DropdownMenuItem(value: '1.0 Acre or Less', child: Text('1.0 Acre or Less')),
                        DropdownMenuItem(value: '2.5 Acres (Agricultural)', child: Text('2.5 Acres (Agricultural)')),
                        DropdownMenuItem(value: 'More than 5 Acres', child: Text('More than 5 Acres')),
                      ],
                      onChanged: (v) => setState(() => _landOwnership = v ?? _landOwnership),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons: Cancel, Review, Save
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _reviewChangesDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E293B),
                      ),
                      child: const Text('Review', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.sync_lock, size: 18),
                label: const Text('Save & Synchronize Changes'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(color: AppTheme.statusRejected, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
