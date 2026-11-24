import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/core/localization/app_strings.dart';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import 'package:graduation_project_flutter/features/my_contracts/presentation/state_management(bloc)/contracts_cubit.dart';

class ContractDetailsScreen extends StatelessWidget {
  final int contractId;

  const ContractDetailsScreen({super.key, required this.contractId});

  String _buildImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=400';
    }
    if (path.startsWith('http')) return path;
    return '${EndPoints.baseUrl}$path';
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          s.isAr ? 'تفاصيل العقد' : 'Contract Details',
          style: TextStyle(
            color: context.titleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
          ),
        ),
        backgroundColor: context.scaffoldBgColor,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        iconTheme: IconThemeData(color: context.titleColor),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ContractsCubit, ContractsState>(
        builder: (context, state) {
          if (state is ContractDetailsLoading || state is ContractsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContractDetailsError) {
            return Center(child: Text(state.message));
          } else if (state is ContractDetailsLoaded) {
            final contract = state.contract;
            final formatter = DateFormat('dd MMM yyyy');

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _buildImageUrl(contract.propertyImage),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.apartment,
                            size: 64,
                            color: context.hintColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    contract.propertyTitle ?? 'Contract #${contract.id}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.titleColor,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (contract.price != null)
                    Text(
                      'EGP ${contract.price!.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.primaryColor,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    title: s.isAr ? 'تفاصيل أساسية' : 'Key Details',
                    children: [
                      _buildDetailRow(
                        context,
                        'Status',
                        contract.status.toUpperCase(),
                        isStatus: true,
                      ),
                      _buildDetailRow(
                        context,
                        'Contract Type',
                        contract.contractType ?? 'N/A',
                      ),
                      if (contract.contractDurationMonths != null)
                        _buildDetailRow(
                          context,
                          'Duration',
                          '${contract.contractDurationMonths} months',
                        ),
                      _buildDetailRow(
                        context,
                        'Start Date',
                        contract.startDate != null
                            ? formatter.format(contract.startDate!)
                            : 'N/A',
                      ),
                      _buildDetailRow(
                        context,
                        'End Date',
                        contract.endDate != null
                            ? formatter.format(contract.endDate!)
                            : 'N/A',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.titleColor,
              fontFamily: AppFonts.font,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isStatus = false,
  }) {
    Color? valueColor;
    if (isStatus) {
      switch (value.toLowerCase()) {
        case 'active':
          valueColor = const Color(0xFF22C55E);
          break;
        case 'completed':
          valueColor = const Color(0xFF3B82F6);
          break;
        case 'terminated':
        case 'cancelled':
          valueColor = const Color(0xFFEF4444);
          break;
        case 'pending':
          valueColor = const Color(0xFFF59E0B);
          break;
        default:
          valueColor = context.hintColor;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: context.hintColor,
                fontFamily: AppFonts.font,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isStatus ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? context.titleColor,
                fontFamily: AppFonts.font,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
