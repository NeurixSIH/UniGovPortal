import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/demo_repository.dart';

class DynamicApplicationFormScreen extends StatefulWidget {
  final VoidCallback onSubmitSuccess;
  final VoidCallback onBack;

  const DynamicApplicationFormScreen({
    super.key,
    required this.onSubmitSuccess,
    required this.onBack,
  });

  @override
  State<DynamicApplicationFormScreen> createState() => _DynamicApplicationFormScreenState();
}

class _DynamicApplicationFormScreenState extends State<DynamicApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final DemoRepository _repo = DemoRepository();

  final int _currentStep = 1; // 0: Eligibility, 1: Details, 2: Documents, 3: Review, 4: Submit
  final TextEditingController _incomeController = TextEditingController(text: '250000');
  final TextEditingController _purposeController = TextEditingController(text: 'College Admission & Scholarship');
  String _financialYear = '2025-2026';
  bool _declarationChecked = true;

  @override
  void dispose() {
    _incomeController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _declarationChecked) {
      _repo.submitApplication(
        serviceId: 'SRV_INCOME_CERT',
        departmentId: 'Revenue Department',
        serviceName: 'Income Certificate',
        data: {
          'annualIncome': int.tryParse(_incomeController.text) ?? 250000,
          'purpose': _purposeController.text,
          'financialYear': _financialYear,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Income Certificate application submitted successfully!'),
          backgroundColor: AppTheme.statusSuccess,
          duration: Duration(seconds: 2),
        ),
      );

      widget.onSubmitSuccess();
    } else if (!_declarationChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the statutory declaration.'),
          backgroundColor: AppTheme.statusRejected,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _repo.citizenUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: widget.onBack,
        ),
        title: const Text('Apply for Income Certificate'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stepper Bar: Eligibility -> Details -> Documents -> Review -> Submit
              _buildStepIndicator(),

              const SizedBox(height: 16),

              // Source Badges Legend
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Data Sources:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                    _SourceTag('Profile Data', AppTheme.primaryBlue),
                    _SourceTag('Department Data', Color(0xFF8E24AA)),
                    _SourceTag('User Input', AppTheme.tealAccent),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Auto-Populated Profile Section
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lock_outline, size: 16, color: AppTheme.textMuted),
                        SizedBox(width: 6),
                        Text(
                          'Auto-Populated Verified Information',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _populatedRow('Citizen ID', user.citizenId, 'Profile Data', AppTheme.primaryBlue),
                    _populatedRow('Full Name', user.fullName, 'Profile Data', AppTheme.primaryBlue),
                    _populatedRow('Date of Birth', '14/05/1996 (Age 29)', 'Profile Data', AppTheme.primaryBlue),
                    _populatedRow('Residential Address', '${user.address['line1']}, ${user.city}', 'Department Data', const Color(0xFF8E24AA)),
                    _populatedRow('Aadhaar Status', 'Verified & Biometrically Linked', 'Department Data', const Color(0xFF8E24AA)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Dynamic Additional Input Fields
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.edit_note, size: 18, color: AppTheme.primaryBlue),
                        SizedBox(width: 6),
                        Text(
                          'Application Details (User Input)',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _label('Annual Family Income (in ₹)', isRequired: true),
                    TextFormField(
                      controller: _incomeController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Income is required' : null,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.currency_rupee, size: 18),
                        hintText: 'e.g. 250000',
                      ),
                    ),

                    const SizedBox(height: 12),

                    _label('Purpose of Certificate', isRequired: true),
                    TextFormField(
                      controller: _purposeController,
                      validator: (v) => v == null || v.isEmpty ? 'Purpose is required' : null,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Higher Education Concession / Scheme',
                      ),
                    ),

                    const SizedBox(height: 12),

                    _label('Financial Assessment Year', isRequired: true),
                    DropdownButtonFormField<String>(
                      initialValue: _financialYear,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: '2025-2026', child: Text('FY 2025-2026 (Current)')),
                        DropdownMenuItem(value: '2024-2025', child: Text('FY 2024-2025')),
                        DropdownMenuItem(value: '2023-2024', child: Text('FY 2023-2024')),
                      ],
                      onChanged: (val) => setState(() => _financialYear = val ?? '2025-2026'),
                    ),

                    const SizedBox(height: 14),

                    // Statutory Declaration Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _declarationChecked,
                            activeColor: AppTheme.primaryBlue,
                            onChanged: (val) => setState(() => _declarationChecked = val ?? false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'I hereby solemnly affirm that the information declared above is true to the best of my knowledge under the Maharashtra Right to Public Services Act.',
                            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Actions: Save Draft & Submit
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Draft saved locally.')),
                        );
                      },
                      child: const Text('Save Draft'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit Application'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Eligibility', 'Details', 'Documents', 'Review', 'Submit'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(steps.length, (i) {
          final isDone = i < _currentStep;
          final isActive = i == _currentStep;
          return Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 11,
                    backgroundColor: isDone
                        ? AppTheme.statusSuccess
                        : (isActive ? AppTheme.primaryBlue : const Color(0xFFCBD5E1)),
                    child: isDone
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : Text('${i + 1}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? AppTheme.primaryBlue : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              if (i < steps.length - 1)
                Container(
                  width: 14,
                  height: 1.5,
                  color: isDone ? AppTheme.statusSuccess : const Color(0xFFCBD5E1),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _populatedRow(String label, String value, String source, Color tagColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 105,
            child: Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          _SourceTag(source, tagColor),
        ],
      ),
    );
  }

  Widget _label(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          if (isRequired) const Text(' *', style: TextStyle(color: AppTheme.statusRejected)),
        ],
      ),
    );
  }
}

class _SourceTag extends StatelessWidget {
  final String label;
  final Color color;

  const _SourceTag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(60), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
