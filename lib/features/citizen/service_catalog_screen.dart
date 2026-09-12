import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/service_model.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';

class ServiceCatalogScreen extends StatefulWidget {
  final ValueChanged<String> onSelectService;
  final ValueChanged<String> onApplyDirectly;

  const ServiceCatalogScreen({
    super.key,
    required this.onSelectService,
    required this.onApplyDirectly,
  });

  @override
  State<ServiceCatalogScreen> createState() => _ServiceCatalogScreenState();
}

class _ServiceCatalogScreenState extends State<ServiceCatalogScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedDeptId = 'ALL';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final services = state.services;
    final departments = state.departments;

    // Filter services
    final filteredServices = services.where((s) {
      final matchesDept = _selectedDeptId == 'ALL' || s.departmentId == _selectedDeptId;
      final matchesQuery = _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.departmentName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesDept && matchesQuery;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blue Banner Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF003B7B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.grid_view_rounded, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'e-GOVERNANCE UNIFIED PORTAL',
                        style: AppTypography.labelBold.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                Text(
                  'Digital Service Catalog & e-Services',
                  style: AppTypography.h1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Explore official services across Central & State ministries. Fast-track application processing with Aadhaar e-KYC.',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Search & Filter Bar
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search service by name, keyword or document requirement...',
                            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Department Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Department:', style: AppTypography.labelBold.copyWith(fontSize: 12, color: AppColors.textPrimary)),
                        const SizedBox(width: AppSpacing.m),
                        _FilterChip(
                          label: 'All Departments (${services.length})',
                          isSelected: _selectedDeptId == 'ALL',
                          onTap: () => setState(() => _selectedDeptId = 'ALL'),
                        ),
                        ...departments.map((d) {
                          final deptCount = services.where((s) => s.departmentId == d.id).length;
                          return Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.s),
                            child: _FilterChip(
                              label: '${d.name} ($deptCount)',
                              isSelected: _selectedDeptId == d.id,
                              onTap: () => setState(() => _selectedDeptId = d.id),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Results counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${filteredServices.length} Government Services',
                style: AppTypography.labelBold.copyWith(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),

          // Services Grid
          if (filteredServices.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textLight),
                      const SizedBox(height: AppSpacing.m),
                      Text('No services matched your query', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Try adjusting your search terms or department filter.', style: AppTypography.bodySmall),
                    ],
                  ),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 950;
                final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 950;
                final crossAxisCount = isWide ? 3 : (isTablet ? 2 : 1);

                if (crossAxisCount == 1) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredServices.length,
                    separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.m),
                    itemBuilder: (context, index) {
                      final srv = filteredServices[index];
                      return _ServiceCard(
                        service: srv,
                        onViewDetails: () => widget.onSelectService(srv.id),
                        onApply: () => widget.onApplyDirectly(srv.id),
                      );
                    },
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredServices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.m,
                    mainAxisSpacing: AppSpacing.m,
                    mainAxisExtent: 310,
                  ),
                  itemBuilder: (context, index) {
                    final srv = filteredServices[index];
                    return _ServiceCard(
                      service: srv,
                      onViewDetails: () => widget.onSelectService(srv.id),
                      onApply: () => widget.onApplyDirectly(srv.id),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent : AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onViewDetails;
  final VoidCallback onApply;

  const _ServiceCard({
    required this.service,
    required this.onViewDetails,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Icon & Fee
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(service.icon, color: AppColors.primary, size: 24),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: service.governmentFee == 0 ? AppColors.successLight : AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(
                      color: service.governmentFee == 0 ? AppColors.successBorder : AppColors.border,
                    ),
                  ),
                  child: Text(
                    service.governmentFee == 0 ? 'FREE' : '₹ ${service.governmentFee.toStringAsFixed(0)}',
                    style: AppTypography.labelSmall.copyWith(
                      color: service.governmentFee == 0 ? AppColors.success : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),

            // Service Title
            Text(
              service.name,
              style: AppTypography.h3.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              service.departmentName,
              style: AppTypography.bodySmall.copyWith(color: AppColors.primaryAccent, fontSize: 11),
            ),
            const SizedBox(height: AppSpacing.s),

            // Description
            Text(
              service.description,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.s),

            // Info row: processing days & documents
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text('${service.processingTimeDays} Days SLA', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                const Spacer(),
                const Icon(Icons.attach_file_rounded, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text('${service.requiredDocuments.length} Docs', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
              ],
            ),
            const SizedBox(height: AppSpacing.m),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Details',
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.small,
                    onPressed: onViewDetails,
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: AppButton(
                    label: 'Apply',
                    variant: AppButtonVariant.primary,
                    size: AppButtonSize.small,
                    leadingIcon: Icons.arrow_forward_rounded,
                    onPressed: onApply,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
