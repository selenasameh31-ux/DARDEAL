import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class RentalManagementScreen extends StatefulWidget {
  const RentalManagementScreen({super.key});

  @override
  State<RentalManagementScreen> createState() => _RentalManagementScreenState();
}

class _RentalManagementScreenState extends State<RentalManagementScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedAmount = "EGP 0";

  @override
  void initState() {
    super.initState();
    // Load data from API when screen starts
    context.read<RentalManagementCubit>().loadRentals();
  }

  // Calculate total from API data
  void _updateTotalAmount(List<dynamic> rentals) {
    double total = rentals.fold(0.0, (sum, r) => sum + (r.monthlyRent ?? 0.0));
    final formatter = NumberFormat('#,###', 'en_US');
    _selectedAmount = "EGP ${formatter.format(total)}";
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) =>
      "${_getMonthName(date.month)} ${date.year}";
      
  String _formatApiDate(String? raw) {
    if (raw == null || raw.isEmpty) return '--';
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return raw;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2100, 12),
      builder: (context, child) => Theme(
        data: theme.copyWith(
          colorScheme: colors,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: context.primaryColor),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      // Filter the API call based on the selected date
      if (context.mounted) {
        context.read<RentalManagementCubit>().loadRentals();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          "Manage Rentals",
          style: TextStyle(
            color: context.titleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.scaffoldBgColor,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: context.titleColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<RentalManagementCubit, RentalManagementState>(
        builder: (context, state) {
          if (state is RentalManagementLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RentalManagementError) {
            return Center(child: Text(state.message, style: TextStyle(color: colors.error)));
          }
          
          List rentals = [];
          if (state is RentalManagementLoaded) {
            rentals = state.data.rentals;
            // Delay updating the state to avoid build phase issues, or do it directly if careful
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                double total = rentals.fold(0.0, (sum, r) => sum + (r.monthlyRent ?? 0.0));
                final formatter = NumberFormat('#,###', 'en_US');
                final newAmount = "EGP ${formatter.format(total)}";
                if (_selectedAmount != newAmount) {
                  setState(() => _selectedAmount = newAmount);
                }
              }
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RentalSummaryCard(
                  title: "Total Monthly Income",
                  amount: _selectedAmount,
                  period: _formatDate(_selectedDate),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: context.textFieldBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: context.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(_selectedDate),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: context.hintColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "RENTERS & PAYMENTS",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.hintColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                if (rentals.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        "No rentals found",
                        style: TextStyle(color: context.hintColor),
                      ),
                    ),
                  )
                else
                  ...rentals.map(
                    (rental) {
                      final status = rental.status?.toLowerCase() ?? 'unknown';
                      final isOverdue = status == 'terminated' || status == 'expired';
                      final isHighlighted = status == 'active';
                      final rent = rental.monthlyRent ?? 0.0;
                      
                      return RentalCard(
                        name: 'Rental #${rental.id}',
                        property: rental.propertyTitle ?? 'Unknown Property',
                        price: 'EGP ${NumberFormat('#,###', 'en_US').format(rent)}',
                        status: rental.status ?? 'Unknown',
                        date: isOverdue ? 'Due ${_formatApiDate(rental.endDate)}' : 'Paid ${_formatApiDate(rental.startDate)}',
                        isOverdue: isOverdue,
                        isHighlighted: isHighlighted,
                        onSendReminder: () => ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Reminder sent'))),
                        onChat: () => ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Chat opened'))),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
