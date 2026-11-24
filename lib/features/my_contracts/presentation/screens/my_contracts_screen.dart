import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/core/localization/app_strings.dart';
import 'package:graduation_project_flutter/features/my_contracts/domain/entities/contract_entity.dart';
import 'package:graduation_project_flutter/features/my_contracts/presentation/state_management(bloc)/contracts_cubit.dart';

class MyContractsScreen extends StatefulWidget {
  const MyContractsScreen({super.key});

  @override
  State<MyContractsScreen> createState() => _MyContractsScreenState();
}

class _MyContractsScreenState extends State<MyContractsScreen> {
  String _selectedTab = 'All';

  static const _tabs = ['All', 'Active', 'Completed', 'Terminated'];

  @override
  void initState() {
    super.initState();
    _fetchContracts();
  }

  void _fetchContracts() {
    String? apiStatus;
    switch (_selectedTab) {
      case 'Active':
        apiStatus = 'active';
        break;
      case 'Completed':
        apiStatus = 'completed';
        break;
      case 'Terminated':
        apiStatus = 'terminated';
        break;
      default:
        apiStatus = null;
    }
    context.read<ContractsCubit>().loadContracts(status: apiStatus);
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF22C55E);
      case 'completed':
        return const Color(0xFF3B82F6);
      case 'terminated':
      case 'cancelled':
        return const Color(0xFFEF4444);
      case 'pending':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Icons.check_circle_outline;
      case 'completed':
        return Icons.task_alt;
      case 'terminated':
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.description_outlined;
    }
  }

  String _buildImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=400';
    }
    if (path.startsWith('http')) return path;
    return '${EndPoints.baseUrl}$path';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = AppStrings.of(context);

    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          s.isAr ? 'عقودي' : 'My Contracts',
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
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: context.titleColor),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ── Tab Bar ──────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _tabs.map((tab) {
                final isSelected = _selectedTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() => _selectedTab = tab);
                          _fetchContracts();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.primaryColor
                                : isDark
                                    ? Colors.white.withOpacity(0.06)
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? context.primaryColor
                                  : isDark
                                      ? Colors.white.withOpacity(0.08)
                                      : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : context.titleColor,
                              fontSize: 13,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 4),

          // ── Content ─────────────────────────────────────
          Expanded(
            child: BlocConsumer<ContractsCubit, ContractsState>(
              listener: (context, state) {
                if (state is ContractsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ContractsLoading || state is ContractsInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ContractsLoaded) {
                  if (state.contracts.isEmpty) {
                    return _buildEmptyState(context, s);
                  }
                  return RefreshIndicator(
                    color: context.primaryColor,
                    onRefresh: () async => _fetchContracts(),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: state.contracts.length,
                      itemBuilder: (context, index) {
                        return _buildContractCard(
                          context,
                          state.contracts[index],
                          isDark,
                        );
                      },
                    ),
                  );
                } else if (state is ContractsError) {
                  return _buildErrorState(context);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppStrings s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.primaryColor.withOpacity(0.08),
            ),
            child: Icon(
              Icons.description_outlined,
              size: 56,
              color: context.primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            s.isAr ? 'لا توجد عقود' : 'No Contracts Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.titleColor,
              fontFamily: AppFonts.font,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            s.isAr
                ? 'عقودك ستظهر هنا بمجرد إنشائها'
                : 'Your contracts will appear here once created',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? context.hintColor : context.hintColor,
              fontFamily: AppFonts.font,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: context.hintColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load contracts',
            style: TextStyle(
              fontSize: 16,
              color: context.titleColor,
              fontFamily: AppFonts.font,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _fetchContracts,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
            style: TextButton.styleFrom(
              foregroundColor: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractCard(
    BuildContext context,
    ContractEntity contract,
    bool isDark,
  ) {
    final statusColor = _statusColor(contract.status);
    final formatter = DateFormat('dd MMM yyyy');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<ContractsCubit>()
                ..loadContractDetails(contract.id),
              child: ContractDetailsScreen(contractId: contract.id),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.grey[200]!,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Property image + status badge ──
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    _buildImageUrl(contract.propertyImage),
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: isDark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.apartment,
                          size: 48,
                          color: context.hintColor.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Status badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _statusIcon(contract.status),
                            size: 14,
                            color: statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            contract.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Contract type badge
                  if (contract.contractType != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          contract.contractType!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Card body ──
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + price
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contract.propertyTitle ?? 'Contract #${contract.id}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.titleColor,
                            fontFamily: AppFonts.font,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (contract.price != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          'EGP ${contract.price!.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: context.primaryColor,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Date range
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: context.hintColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        contract.startDate != null && contract.endDate != null
                            ? '${formatter.format(contract.startDate!)} — ${formatter.format(contract.endDate!)}'
                            : 'Dates not set',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.hintColor,
                          fontFamily: AppFonts.font,
                        ),
                      ),
                    ],
                  ),

                  if (contract.contractDurationMonths != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.timelapse_outlined,
                          size: 14,
                          color: context.hintColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${contract.contractDurationMonths} months',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.hintColor,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

                  // View details button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => sl<ContractsCubit>()
                                ..loadContractDetails(contract.id),
                              child: ContractDetailsScreen(
                                contractId: contract.id,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: Text(
                        AppStrings.of(context).isAr
                            ? 'عرض التفاصيل'
                            : 'View Details',
                        style: const TextStyle(fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.primaryColor,
                        side: BorderSide(
                          color: context.primaryColor.withOpacity(0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
