import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_flutter/core/root/injection_container.dart';
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/features/offer_profile/presentation/state_management(bloc)/my_offers_cubit.dart';
import 'package:graduation_project_flutter/features/offer/presentation/screens/payment_deposit_screen.dart';
import 'package:graduation_project_flutter/features/offer/presentation/state_management/bloc/offer_bloc.dart';

class MyOffersScreen extends StatelessWidget {
  const MyOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "My Offers",
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
      body: BlocProvider(
        create: (context) => sl<MyOffersCubit>()..fetchMyOffers(),
        child: BlocBuilder<MyOffersCubit, MyOffersState>(
          builder: (context, state) {
            if (state is MyOffersInitial || state is MyOffersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyOffersError) {
              return Center(child: Text(state.message));
            } else if (state is MyOffersLoaded) {
              final offers = state.offers;

              if (offers.isEmpty) {
                return const Center(child: Text("No Offers Found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  // Map API data to the OfferCard. Keep the styling as it was.
                  final isAccepted =
                      offer.status.name.toUpperCase() == 'ACCEPTED';
                  final isRejected =
                      offer.status.name.toUpperCase() == 'REJECTED';
                  final isPending =
                      offer.status.name.toUpperCase() == 'PENDING';

                  String? btnText;
                  if (isAccepted) {
                    btnText = "Pay Deposit";
                  } else if (isRejected) {
                    btnText = "View Reason";
                  } else {
                    btnText = "View Details";
                  }

                  return OfferCard(
                    status: offer.status.name.toUpperCase(),
                    statusColor: isAccepted
                        ? Colors.green
                        : (isRejected ? Colors.red : context.primaryColor),
                    title: "Property Offer",
                    price: "${offer.offerPrice} EGP",
                    image:
                        "https://images.unsplash.com/photo-1560185007-cde436f6a4d0", // placeholder
                    buttonText: btnText,
                    showAction: !isRejected,
                    currentStep: isAccepted ? 3 : (isPending ? 2 : 1),
                    onTap: () {
                      if (isAccepted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => sl<OfferBloc>(),
                              child: PaymentDepositScreen(
                                offerId: offer.id.toString(),
                              ),
                            ),
                          ),
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          Routes.propertyDetailsRent,
                          arguments: int.tryParse(offer.propertyId.toString()) ?? 0,
                        );
                      }
                    },
                  );
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
