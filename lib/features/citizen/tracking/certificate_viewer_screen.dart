import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/application_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class CertificateViewerScreen extends StatefulWidget {
  final ApplicationModel application;
  final VoidCallback onBack;

  const CertificateViewerScreen({
    super.key,
    required this.application,
    required this.onBack,
  });

  @override
  State<CertificateViewerScreen> createState() => _CertificateViewerScreenState();
}

class _CertificateViewerScreenState extends State<CertificateViewerScreen> {
  double _zoomScale = 1.0;

  @override
  Widget build(BuildContext context) {
    final certNo = widget.application.certificateNumber ?? 'CERT-REV-2026-9182';
    final issueDate = widget.application.certificateIssueDate ?? widget.application.lastUpdated;
    final expiryDate = widget.application.certificateExpiryDate ?? issueDate.add(const Duration(days: 365 * 3));
    final signedBy = widget.application.certificateSignedBy ?? 'Priya Verma, IAS, Sub-Divisional Magistrate';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Action Toolbar
              Wrap(
                spacing: AppSpacing.m,
                runSpacing: AppSpacing.s,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Back to Application'),
                  ),
                  Wrap(
                    spacing: AppSpacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.zoom_out_rounded),
                        tooltip: 'Zoom Out',
                        onPressed: () {
                          setState(() {
                            if (_zoomScale > 0.8) _zoomScale -= 0.1;
                          });
                        },
                      ),
                      Text('${(_zoomScale * 100).toInt()}%', style: AppTypography.labelSmall),
                      IconButton(
                        icon: const Icon(Icons.zoom_in_rounded),
                        tooltip: 'Zoom In',
                        onPressed: () {
                          setState(() {
                            if (_zoomScale < 1.4) _zoomScale += 0.1;
                          });
                        },
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      AppButton(
                        label: 'Download PDF',
                        size: AppButtonSize.small,
                        leadingIcon: Icons.download_rounded,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Official Certificate $certNo downloaded.')),
                          );
                        },
                      ),
                      AppButton(
                        label: 'Share',
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.small,
                        leadingIcon: Icons.share_rounded,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Certificate verification link copied to clipboard.')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),

              // The Certificate Canvas / Card with horizontal scroll for mobile
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                    child: Transform.scale(
                      scale: _zoomScale,
                      child: Container(
                        width: 780,
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(color: const Color(0xFFD4AF37), width: 3), // Gold Border
                          boxShadow: const [
                            BoxShadow(color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, 8)),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Inner ornamental border
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0x33D4AF37), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Emblem & Header
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primarySurface,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/images/gov_logo.png',
                                      height: 48,
                                      width: 48,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.account_balance_rounded,
                                        size: 40,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.s),
                                  Text(
                                    'GOVERNMENT OF INDIA • SETU PORTAL',
                                    style: AppTypography.labelBold.copyWith(letterSpacing: 2.0, color: AppColors.primary),
                                  ),
                              Text(
                                widget.application.departmentName.toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(letterSpacing: 1.2, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: AppSpacing.s),
                              Text(
                                'OFFICIAL PUBLIC RECORD CERTIFICATE',
                                style: AppTypography.h2.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.m),
                              const Divider(color: Color(0xFFD4AF37), thickness: 1.5),
                              const SizedBox(height: AppSpacing.m),

                              // Certificate Reference Numbers
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Certificate No: $certNo',
                                    style: AppTypography.code.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Text(
                                    'Issued: ${DateFormat("dd/MM/yyyy").format(issueDate)} • Valid Thru: ${DateFormat("dd/MM/yyyy").format(expiryDate)}',
                                    style: AppTypography.code.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xl),

                              // Certificate Body
                              Text(
                                'This is to formally certify that pursuant to statutory scrutiny under the relevant Service Acts and Revenue Rules, the application of:',
                                style: AppTypography.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.m),

                              Text(
                                widget.application.citizenName.toUpperCase(),
                                style: AppTypography.h2.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Aadhaar Identification: ${widget.application.citizenAadhaar}',
                                style: AppTypography.code.copyWith(fontSize: 13, color: AppColors.textSecondary),
                              ),
                              Text(
                                'Resident of: ${widget.application.citizenAddress}',
                                style: AppTypography.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.l),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.m),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceSubtle,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'CERTIFIED SERVICE ENDORSEMENT:',
                                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.application.serviceName,
                                      style: AppTypography.h3.copyWith(color: AppColors.primaryAccent),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (widget.application.formData.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Verified Record Reference: ${widget.application.formData.values.take(2).join(" • ")}',
                                        style: AppTypography.bodySmall,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),

                              Text(
                                'This document is issued electronically under the Information Technology Act 2000 and requires no physical ink signature.',
                                style: AppTypography.bodySmall.copyWith(fontSize: 11, fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.xl),

                              // Bottom Row: QR Code & Digital Signature
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Verifiable QR Barcode Box
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.s),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceSubtle,
                                            border: Border.all(color: AppColors.border),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.qr_code_2_rounded, size: 75, color: AppColors.primaryDark),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text('Scan to Verify', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                                      ],
                                    ),
                                  ),

                                  // Digital Signature Stamp
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.m),
                                    decoration: BoxDecoration(
                                      color: AppColors.successLight,
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                      border: Border.all(color: AppColors.successBorder),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.verified_rounded, size: 16, color: AppColors.success),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Digitally Signed by Authority',
                                              style: AppTypography.labelSmall.copyWith(
                                                color: AppColors.success,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(signedBy, style: AppTypography.labelBold.copyWith(fontSize: 12)),
                                        Text(
                                          'Signed: ${DateFormat("dd/MM/yyyy HH:mm:ss").format(issueDate)} IST',
                                          style: AppTypography.code.copyWith(fontSize: 10),
                                        ),
                                        Text(
                                          'SHA-256: 7F81...A429',
                                          style: AppTypography.code.copyWith(fontSize: 9, color: AppColors.textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
          ),
        ),
      ),
    );
  }
}
