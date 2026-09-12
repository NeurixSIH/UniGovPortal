import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/models/application_model.dart';
import '../../../core/models/application_status.dart';
import '../../../core/models/service_model.dart';
import '../../../core/state/app_state_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class ApplicationWizardScreen extends StatefulWidget {
  final ServiceModel service;
  final VoidCallback onCancel;
  final ValueChanged<String> onSubmittedSuccess;

  const ApplicationWizardScreen({
    super.key,
    required this.service,
    required this.onCancel,
    required this.onSubmittedSuccess,
  });

  @override
  State<ApplicationWizardScreen> createState() => _ApplicationWizardScreenState();
}

class _ApplicationWizardScreenState extends State<ApplicationWizardScreen> {
  int _currentStep = 0;
  final List<String> _stepTitles = [
    '1. Applicant',
    '2. Details',
    '3. Documents',
    '4. Review',
    '5. Consent',
    '6. Complete',
  ];

  // Form Field Values
  final Map<String, dynamic> _formData = {};

  // Uploaded Documents state
  final Map<String, UploadedDocument> _uploadedDocs = {};
  final Map<String, bool> _uploadingState = {};
  final Map<String, double> _uploadProgress = {};

  // Consent checkboxes
  bool _consentTruthful = false;
  bool _consentAadhaarVerification = false;
  bool _consentTermsAccepted = false;

  bool _isSubmitting = false;
  String? _generatedAppId;

  late TextEditingController _wizFullNameCtrl;
  late TextEditingController _wizAadhaarCtrl;
  late TextEditingController _wizDobGenderCtrl;
  late TextEditingController _wizMobileCtrl;
  late TextEditingController _wizAddressCtrl;

  @override
  void initState() {
    super.initState();
    final citizen = DemoData.citizenProfile;
    _wizFullNameCtrl = TextEditingController(text: citizen['fullName']);
    _wizAadhaarCtrl = TextEditingController(text: citizen['maskedAadhaar']);
    _wizDobGenderCtrl = TextEditingController(text: '${citizen["dob"]} (${citizen["gender"]})');
    _wizMobileCtrl = TextEditingController(text: citizen['mobile']);
    _wizAddressCtrl = TextEditingController(text: citizen['address']);

    // Initialize default values for dynamic fields if any
    for (final field in widget.service.formFields) {
      if (field.defaultValue != null) {
        _formData[field.key] = field.defaultValue;
      }
    }
  }

  @override
  void dispose() {
    _wizFullNameCtrl.dispose();
    _wizAadhaarCtrl.dispose();
    _wizDobGenderCtrl.dispose();
    _wizMobileCtrl.dispose();
    _wizAddressCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _jumpToStep(int step) {
    setState(() => _currentStep = step);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wizard Header Bar
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 600;
                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Application Submission Wizard', style: AppTypography.h2),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.service.name} • ${widget.service.departmentName}',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.primaryAccent),
                        ),
                        if (_currentStep < 5) ...[
                          const SizedBox(height: AppSpacing.s),
                          AppButton(
                            label: 'Save Draft & Exit',
                            variant: AppButtonVariant.outline,
                            size: AppButtonSize.small,
                            leadingIcon: Icons.save_outlined,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Draft saved locally in your active session.')),
                              );
                              widget.onCancel();
                            },
                          ),
                        ],
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Application Submission Wizard', style: AppTypography.h1),
                            Text(
                              '${widget.service.name} • ${widget.service.departmentName}',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.primaryAccent),
                            ),
                          ],
                        ),
                      ),
                      if (_currentStep < 5)
                        AppButton(
                          label: 'Save Draft & Exit',
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.small,
                          leadingIcon: Icons.save_outlined,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Draft saved locally in your active session.')),
                            );
                            widget.onCancel();
                          },
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.l),

              // Stepper Progress Indicator
              _buildStepperIndicator(),
              const SizedBox(height: AppSpacing.xl),

              // Step Content Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: _buildCurrentStepContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_stepTitles.length, (index) {
            final isCompleted = index < _currentStep;
            final isCurrent = index == _currentStep;

            return Row(
              children: [
                InkWell(
                  onTap: isCompleted ? () => _jumpToStep(index) : null,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? AppColors.primaryAccent
                              : (isCompleted ? AppColors.success : AppColors.surfaceSubtle),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCurrent
                                ? AppColors.primaryAccent
                                : (isCompleted ? AppColors.success : AppColors.border),
                          ),
                        ),
                        child: isCompleted
                            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrent ? Colors.white : AppColors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        _stepTitles[index].substring(3),
                        style: AppTypography.labelSmall.copyWith(
                          color: isCurrent
                              ? AppColors.primary
                              : (isCompleted ? AppColors.textPrimary : AppColors.textLight),
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < _stepTitles.length - 1)
                  Container(
                    width: 32,
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
                    color: isCompleted ? AppColors.success : AppColors.border,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStepApplicant();
      case 1:
        return _buildStepDetails();
      case 2:
        return _buildStepDocuments();
      case 3:
        return _buildStepReview();
      case 4:
        return _buildStepConsent();
      case 5:
        return _buildStepSubmitted();
      default:
        return const SizedBox.shrink();
    }
  }

  // ==========================================
  // STEP 1: APPLICANT IDENTITY (Pre-filled e-KYC)
  // ==========================================
  Widget _buildStepApplicant() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
              child: const Icon(Icons.person_pin_rounded, color: AppColors.primaryAccent),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step 1: Verified Applicant Identity', style: AppTypography.h3),
                  Text('Pre-populated from UIDAI Aadhaar e-KYC records in accordance with IT Act 2000.', style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.l),

        LayoutBuilder(
          builder: (context, constraints) {
            final fieldWidth = constraints.maxWidth > 650 ? (constraints.maxWidth - AppSpacing.l) / 2 : double.infinity;
            return Wrap(
              spacing: AppSpacing.l,
              runSpacing: AppSpacing.m,
              children: [
                SizedBox(
                  width: fieldWidth,
                  child: AppTextField(
                    label: 'Applicant Full Name',
                    readOnly: true,
                    controller: _wizFullNameCtrl,
                    prefixIcon: const Icon(Icons.verified_user_rounded, color: AppColors.success, size: 18),
                    helperText: 'Verified via Aadhaar Biometric / OTP Registry',
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: AppTextField(
                    label: 'Aadhaar Identification Number',
                    readOnly: true,
                    controller: _wizAadhaarCtrl,
                    prefixIcon: const Icon(Icons.credit_card_rounded, size: 18),
                    helperText: 'Masked format for statutory privacy compliance',
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: AppTextField(
                    label: 'Date of Birth & Gender',
                    readOnly: true,
                    controller: _wizDobGenderCtrl,
                    prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: AppTextField(
                    label: 'Registered Mobile Number',
                    readOnly: true,
                    controller: _wizMobileCtrl,
                    prefixIcon: const Icon(Icons.phone_android_rounded, size: 18),
                    helperText: 'SMS alerts will be dispatched to this number',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.m),

        AppTextField(
          label: 'Official Permanent Address',
          readOnly: true,
          controller: _wizAddressCtrl,
          prefixIcon: const Icon(Icons.home_outlined, size: 18),
          maxLines: 2,
        ),
        const SizedBox(height: AppSpacing.xl),

        // Stepper Navigation Buttons
        _buildNavigationButtons(
          context: context,
          backButton: AppButton(
            label: 'Cancel',
            variant: AppButtonVariant.outline,
            onPressed: widget.onCancel,
          ),
          nextButton: AppButton(
            label: 'Continue to Service Details',
            trailingIcon: Icons.arrow_forward_rounded,
            onPressed: _nextStep,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // STEP 2: DYNAMIC SERVICE DETAILS
  // ==========================================
  Widget _buildStepDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
              child: const Icon(Icons.description_outlined, color: AppColors.primaryAccent),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step 2: Service-Specific Application Data', style: AppTypography.h3),
                  Text('Please answer the official questions required for ${widget.service.name}.', style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.l),

        // Dynamic Form Fields rendering
        ...widget.service.formFields.map((field) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.l),
            child: _buildDynamicField(field),
          );
        }),

        const SizedBox(height: AppSpacing.l),
        _buildNavigationButtons(
          context: context,
          backButton: AppButton(
            label: 'Back',
            variant: AppButtonVariant.outline,
            leadingIcon: Icons.arrow_back_rounded,
            onPressed: _prevStep,
          ),
          nextButton: AppButton(
            label: 'Continue to Documents',
            trailingIcon: Icons.arrow_forward_rounded,
            onPressed: () {
              // Validate required fields
              for (final field in widget.service.formFields) {
                if (field.required) {
                  final val = _formData[field.key];
                  if (val == null || (val is String && val.trim().isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please complete mandatory field: "${field.label}"'),
                        backgroundColor: AppColors.danger,
                      ),
                    );
                    return;
                  }
                }
              }
              _nextStep();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicField(FormFieldDefinition field) {
    if (field.type == FormFieldType.dropdown && field.options != null) {
      final currentVal = _formData[field.key] as String?;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(field.label, style: AppTypography.labelBold),
              if (field.required) ...[
                const SizedBox(width: AppSpacing.xs),
                Text('*', style: AppTypography.labelBold.copyWith(color: AppColors.danger)),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          DropdownButtonFormField<String>(
            value: currentVal,
            decoration: InputDecoration(
              hintText: field.hint,
              helperText: field.helperText,
              helperMaxLines: 2,
            ),
            items: field.options!
                .map(
                  (opt) => DropdownMenuItem(
                    value: opt.value,
                    child: Text(opt.label),
                  ),
                )
                .toList(),
            onChanged: (val) {
              setState(() => _formData[field.key] = val);
            },
          ),
        ],
      );
    } else if (field.type == FormFieldType.date) {
      final dateVal = _formData[field.key] as String? ?? '2026-09-25';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(field.label, style: AppTypography.labelBold),
              if (field.required) ...[
                const SizedBox(width: AppSpacing.xs),
                Text('*', style: AppTypography.labelBold.copyWith(color: AppColors.danger)),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime(1940),
                lastDate: DateTime(2035),
              );
              if (picked != null) {
                setState(() => _formData[field.key] = DateFormat('yyyy-MM-dd').format(picked));
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primaryAccent),
                  const SizedBox(width: AppSpacing.m),
                  Text(
                    dateVal.isNotEmpty ? dateVal : field.hint,
                    style: AppTypography.bodyMedium.copyWith(
                      color: dateVal.isNotEmpty ? AppColors.textPrimary : AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return AppTextField(
        label: field.label,
        hint: field.hint,
        helperText: field.helperText,
        prefixText: field.prefixText,
        isRequired: field.required,
        keyboardType: field.type == FormFieldType.number ? TextInputType.number : TextInputType.text,
        maxLines: field.type == FormFieldType.textarea ? 3 : 1,
        onChanged: (val) => _formData[field.key] = val,
      );
    }
  }

  // ==========================================
  // STEP 3: DOCUMENT UPLOAD (All Visual States)
  // ==========================================
  Widget _buildStepDocuments() {
    final docs = widget.service.requiredDocuments;
    final allMandatoryUploaded = docs.where((d) => d.isMandatory).every((d) => _uploadedDocs.containsKey(d.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
              child: const Icon(Icons.upload_file_rounded, color: AppColors.primaryAccent),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step 3: Document Uploads', style: AppTypography.h3),
                  Text('Upload clear, legible copies. Supported: PDF, JPG, PNG (Max 5MB each).', style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.l),

        // Document Cards list with full visual states
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
          itemBuilder: (context, index) {
            final docDef = docs[index];
            final uploaded = _uploadedDocs[docDef.id];
            final isUploading = _uploadingState[docDef.id] ?? false;
            final progress = _uploadProgress[docDef.id] ?? 0.0;

            return _buildDocumentUploadCard(
              docDef: docDef,
              uploaded: uploaded,
              isUploading: isUploading,
              progress: progress,
            );
          },
        ),

        const SizedBox(height: AppSpacing.xl),

        // Notice
        if (allMandatoryUploaded)
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.successBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    'All required documents uploaded successfully! Proceed to review your application.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: AppSpacing.l),

        _buildNavigationButtons(
          context: context,
          backButton: AppButton(
            label: 'Back',
            variant: AppButtonVariant.outline,
            leadingIcon: Icons.arrow_back_rounded,
            onPressed: _prevStep,
          ),
          nextButton: AppButton(
            label: 'Continue to Review',
            trailingIcon: Icons.arrow_forward_rounded,
            onPressed: () {
              if (!allMandatoryUploaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please upload all mandatory documents before continuing.'),
                    backgroundColor: AppColors.danger,
                  ),
                );
                return;
              }
              _nextStep();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentUploadCard({
    required RequiredDocumentDefinition docDef,
    required UploadedDocument? uploaded,
    required bool isUploading,
    required double progress,
  }) {
    final isDone = uploaded != null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: isDone ? AppColors.surfaceSubtle : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isDone ? AppColors.successBorder : AppColors.border,
          width: isDone ? 1.5 : 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 560;

          final infoColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      docDef.name,
                      style: AppTypography.labelBold.copyWith(fontSize: 14),
                    ),
                  ),
                  if (docDef.isMandatory)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.dangerLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Required',
                        style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.danger),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(docDef.description, style: AppTypography.bodySmall),
              if (isDone) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.attach_file_rounded, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${uploaded.fileName} (${(uploaded.fileSizeBytes / 1024).toStringAsFixed(0)} KB) • Uploaded',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );

          Widget actionWidget;
          if (isUploading) {
            actionWidget = SizedBox(
              width: 100,
              child: Column(
                children: [
                  LinearProgressIndicator(value: progress, minHeight: 6),
                  const SizedBox(height: 4),
                  Text('${(progress * 100).toInt()}%', style: AppTypography.labelSmall),
                ],
              ),
            );
          } else if (isDone) {
            actionWidget = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  tooltip: 'Preview Document',
                  onPressed: () => _showPreviewDialog(uploaded),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  tooltip: 'Replace Document',
                  onPressed: () => _simulateUpload(docDef),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.danger),
                  tooltip: 'Remove',
                  onPressed: () {
                    setState(() => _uploadedDocs.remove(docDef.id));
                  },
                ),
              ],
            );
          } else {
            actionWidget = AppButton(
              label: 'Upload File',
              variant: AppButtonVariant.outline,
              size: AppButtonSize.small,
              leadingIcon: Icons.upload_file_rounded,
              onPressed: () => _simulateUpload(docDef),
            );
          }

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDone ? AppColors.successLight : AppColors.primarySurface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDone ? Icons.check_circle_rounded : Icons.file_upload_outlined,
                        color: isDone ? AppColors.success : AppColors.primaryAccent,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(child: infoColumn),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Align(
                  alignment: Alignment.centerRight,
                  child: actionWidget,
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDone ? AppColors.successLight : AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.file_upload_outlined,
                  color: isDone ? AppColors.success : AppColors.primaryAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(child: infoColumn),
              const SizedBox(width: AppSpacing.m),
              actionWidget,
            ],
          );
        },
      ),
    );
  }

  void _simulateUpload(RequiredDocumentDefinition docDef) async {
    setState(() {
      _uploadingState[docDef.id] = true;
      _uploadProgress[docDef.id] = 0.1;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 60));
      if (!mounted) return;
      setState(() => _uploadProgress[docDef.id] = i / 10.0);
    }

    if (!mounted) return;
    setState(() {
      _uploadingState[docDef.id] = false;
      _uploadedDocs[docDef.id] = UploadedDocument(
        docId: docDef.id,
        name: docDef.name,
        fileName: '${docDef.name.replaceAll(" ", "_")}.pdf',
        fileSizeBytes: 1250000,
        uploadedAt: DateTime.now(),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Document "${docDef.name}" uploaded successfully.')),
    );
  }

  void _showPreviewDialog(UploadedDocument doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: Row(
          children: [
            const Icon(Icons.picture_as_pdf_rounded, color: AppColors.danger),
            const SizedBox(width: AppSpacing.s),
            Expanded(child: Text(doc.name, style: AppTypography.h3)),
          ],
        ),
        content: Container(
          width: 500,
          height: 380,
          decoration: BoxDecoration(
            color: AppColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.document_scanner_rounded, size: 54, color: AppColors.primaryAccent),
                const SizedBox(height: AppSpacing.m),
                Text(doc.fileName, style: AppTypography.labelBold),
                Text(
                  'Size: ${(doc.fileSizeBytes / 1024).toStringAsFixed(0)} KB • Scanned on ${DateFormat("dd/MM/yyyy").format(doc.uploadedAt)}',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.l),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(color: AppColors.successBorder),
                  ),
                  child: Text('Document Verified by UIDAI / DigiLocker', style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
                ),
              ],
            ),
          ),
        ),
        actions: [
          AppButton(
            label: 'Close Preview',
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 4: REVIEW APPLICATION SUMMARY
  // ==========================================
  Widget _buildStepReview() {
    final citizen = DemoData.citizenProfile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
              child: const Icon(Icons.rate_review_outlined, color: AppColors.primaryAccent),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step 4: Final Review & Scrutiny', style: AppTypography.h3),
                  Text('Carefully verify all details before granting consent and formal submission.', style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.l),

        // Section A: Applicant Info
        _buildReviewSection(
          title: 'Section A: Applicant Profile Details',
          onEdit: () => _jumpToStep(0),
          children: [
            _buildReviewRow('Full Legal Name', citizen['fullName']),
            _buildReviewRow('Aadhaar Number', citizen['maskedAadhaar']),
            _buildReviewRow('Date of Birth', citizen['dob']),
            _buildReviewRow('Registered Phone', citizen['mobile']),
            _buildReviewRow('Residential Address', citizen['address']),
          ],
        ),
        const SizedBox(height: AppSpacing.l),

        // Section B: Service Details
        _buildReviewSection(
          title: 'Section B: Specific Service Information',
          onEdit: () => _jumpToStep(1),
          children: widget.service.formFields.map((f) {
            final val = _formData[f.key]?.toString() ?? 'N/A';
            return _buildReviewRow(f.label, val);
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.l),

        // Section C: Uploaded Documents
        _buildReviewSection(
          title: 'Section C: Enclosed Documents (${_uploadedDocs.length})',
          onEdit: () => _jumpToStep(2),
          children: _uploadedDocs.values.map((d) {
            return _buildReviewRow(d.name, '${d.fileName} (${(d.fileSizeBytes / 1024).toStringAsFixed(0)} KB)');
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.xl),

        _buildNavigationButtons(
          context: context,
          backButton: AppButton(
            label: 'Back',
            variant: AppButtonVariant.outline,
            leadingIcon: Icons.arrow_back_rounded,
            onPressed: _prevStep,
          ),
          nextButton: AppButton(
            label: 'Proceed to Consent & Declaration',
            trailingIcon: Icons.arrow_forward_rounded,
            onPressed: _nextStep,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection({
    required String title,
    required VoidCallback onEdit,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.labelBold),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 14),
                label: const Text('Edit Section'),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.s),
          ...children,
        ],
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 480) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.labelBold.copyWith(fontSize: 13)),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                flex: 3,
                child: Text(value, style: AppTypography.labelBold.copyWith(fontSize: 13)),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // STEP 5: CONSENT & DECLARATION
  // ==========================================
  Widget _buildStepConsent() {
    final canSubmit = _consentTruthful && _consentAadhaarVerification && _consentTermsAccepted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
              child: const Icon(Icons.gavel_rounded, color: AppColors.primaryAccent),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step 5: Citizen Statutory Declaration', style: AppTypography.h3),
                  Text('Mandatory legal declaration under Indian Penal Code and Aadhaar Act 2016.', style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.l),
        const Divider(),
        const SizedBox(height: AppSpacing.l),

        CheckboxListTile(
          value: _consentTruthful,
          onChanged: (val) => setState(() => _consentTruthful = val ?? false),
          title: Text(
            'Truthfulness of Information & Affidavit',
            style: AppTypography.labelBold.copyWith(fontSize: 14),
          ),
          subtitle: Text(
            'I solemnly declare that the particulars furnished above are true and complete to the best of my knowledge. I understand that submitting false or fabricated documents is a cognizable offense punishable under Section 199 and 200 of the Indian Penal Code.',
            style: AppTypography.bodySmall,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.m),

        CheckboxListTile(
          value: _consentAadhaarVerification,
          onChanged: (val) => setState(() => _consentAadhaarVerification = val ?? false),
          title: Text(
            'Consent for Aadhaar e-KYC & Inter-Agency Verification',
            style: AppTypography.labelBold.copyWith(fontSize: 14),
          ),
          subtitle: Text(
            'I hereby grant voluntary consent to the concerned Department to fetch, verify and authenticate my demographic credentials from UIDAI, DigiLocker, and state land/ration registers for processing this application.',
            style: AppTypography.bodySmall,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.m),

        CheckboxListTile(
          value: _consentTermsAccepted,
          onChanged: (val) => setState(() => _consentTermsAccepted = val ?? false),
          title: Text(
            'Terms of Public Service Delivery & SMS/WhatsApp Notification',
            style: AppTypography.labelBold.copyWith(fontSize: 14),
          ),
          subtitle: Text(
            'I accept the Citizen Charter SLAs and authorize Setu to transmit processing updates, scrutiny notices and certificate dispatch notifications to my registered mobile.',
            style: AppTypography.bodySmall,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.xl),

        _buildNavigationButtons(
          context: context,
          backButton: AppButton(
            label: 'Back',
            variant: AppButtonVariant.outline,
            leadingIcon: Icons.arrow_back_rounded,
            onPressed: _prevStep,
          ),
          nextButton: AppButton(
            label: 'Submit Application',
            variant: canSubmit ? AppButtonVariant.primary : AppButtonVariant.outline,
            size: AppButtonSize.large,
            isLoading: _isSubmitting,
            leadingIcon: Icons.send_rounded,
            onPressed: canSubmit ? _handleFinalSubmit : null,
          ),
        ),
      ],
    );
  }

  void _handleFinalSubmit() async {
    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    final state = context.read<AppStateProvider>();
    final appId = 'APP-2026-${widget.service.code.split("-").first}-${(1000 + state.applications.length * 17)}';

    final newApp = ApplicationModel(
      id: appId,
      serviceId: widget.service.id,
      serviceName: widget.service.name,
      departmentId: widget.service.departmentId,
      departmentName: widget.service.departmentName,
      citizenId: DemoData.citizenProfile['id'],
      citizenName: DemoData.citizenProfile['fullName'],
      citizenAadhaar: DemoData.citizenProfile['maskedAadhaar'],
      citizenPhone: DemoData.citizenProfile['mobile'],
      citizenEmail: DemoData.citizenProfile['email'],
      citizenAddress: DemoData.citizenProfile['address'],
      status: AppStatus.submitted,
      submissionDate: DateTime.now(),
      lastUpdated: DateTime.now(),
      formData: Map.from(_formData),
      documents: _uploadedDocs.values.toList(),
      timeline: [
        TimelineEvent(
          stage: AppStatus.submitted,
          title: 'Application Submitted Online',
          description: 'Application successfully registered on Setu central registry.',
          timestamp: DateTime.now(),
          actorRole: 'Citizen',
          actorName: DemoData.citizenProfile['fullName'],
        ),
      ],
    );

    state.submitNewApplication(newApp);

    setState(() {
      _isSubmitting = false;
      _generatedAppId = appId;
      _currentStep = 5;
    });
  }

  // ==========================================
  // STEP 6: APPLICATION SUBMITTED SUCCESS (C-11)
  // ==========================================
  Widget _buildStepSubmitted() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.successBorder, width: 2),
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 54),
            ),
            const SizedBox(height: AppSpacing.l),
            Text('Application Submitted Successfully!', style: AppTypography.h1, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Your service request has been logged with the central registry and assigned for Level-1 document scrutiny.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Reference Number Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Text('ACKNOWLEDGMENT APPLICATION ID', style: AppTypography.labelSmall),
                  const SizedBox(height: 4),
                  Text(
                    _generatedAppId ?? 'APP-2026-REV-1082',
                    style: AppTypography.code.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Submission Date: ${DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.now())}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Action Buttons
            _buildNavigationButtons(
              context: context,
              backButton: AppButton(
                label: 'Download Acknowledgment Receipt',
                variant: AppButtonVariant.outline,
                leadingIcon: Icons.download_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Acknowledgment slip PDF downloaded successfully.')),
                  );
                },
              ),
              nextButton: AppButton(
                label: 'Track This Application',
                variant: AppButtonVariant.primary,
                leadingIcon: Icons.timeline_rounded,
                onPressed: () {
                  if (_generatedAppId != null) {
                    widget.onSubmittedSuccess(_generatedAppId!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons({
    required BuildContext context,
    AppButton? backButton,
    required AppButton nextButton,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 500;
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              nextButton,
              if (backButton != null) ...[
                const SizedBox(height: AppSpacing.m),
                backButton,
              ],
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (backButton != null) backButton else const SizedBox.shrink(),
            nextButton,
          ],
        );
      },
    );
  }
}
