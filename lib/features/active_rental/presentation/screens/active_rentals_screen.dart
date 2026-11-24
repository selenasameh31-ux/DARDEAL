import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/core/root/injection_container.dart';
import 'package:graduation_project_flutter/features/active_rental/presentation/state_management(bloc)/active_rentals_cubit.dart';
import 'package:graduation_project_flutter/features/active_rental/presentation/state_management(bloc)/active_rentals_state.dart';
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ActiveRentalsScreen extends StatelessWidget {
  const ActiveRentalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => sl<ActiveRentalsCubit>()..getRentals(),
      child: Scaffold(
        backgroundColor: context.scaffoldBgColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          backgroundColor: context.scaffoldBgColor,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 56,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: context.titleColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Active Rentals",
            style: TextStyle(
              color: context.titleColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.font,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.tune, color: context.primaryColor, size: 22),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocBuilder<ActiveRentalsCubit, ActiveRentalsState>(
          builder: (context, state) {
            if (state is ActiveRentalsInitial || state is ActiveRentalsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ActiveRentalsError) {
              return Center(child: Text(state.message));
            } else if (state is ActiveRentalsSuccess) {
              final rentals = state.rentalsData.rentals;

              if (rentals.isEmpty) {
                return const Center(child: Text("No Active Rentals"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: rentals.length + 2, // +2 للهيدر والفوتر
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // الهيدر
                    return Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.apartment, color: context.primaryColor, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You have ${rentals.length} active properties in Egypt",
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.titleColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Manage your rentals and payments",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: context.hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (index == rentals.length + 1) {
                    // الفوتر
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Help center - coming soon'),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.help_outline, size: 18, color: context.primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                "Need help with your rental?",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: context.primaryColor,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    final rental = rentals[index - 1];
                    return ActiveRentalCard(
                      imageUrl: 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=200',
                      title: rental.propertyTitle ?? '',
                      location: 'Egypt',
                      dueDate: rental.endDate ?? '',
                      price: '${rental.monthlyRent} EGP',
                      onPaymentHistory: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment history')),
                        );
                      },
                      onPayNow: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Proceed to payment')),
                        );
                      },
                      onViewContract: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('View contract')));
                      },
                    );
                  }
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
