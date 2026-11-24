import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class OfferFlowScreen extends StatelessWidget {
  final String propertyId;

  const OfferFlowScreen({
    super.key,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OfferBloc>()..add(LoadPropertyForOffer(propertyId)),
      child: MakeOfferScreen(
        propertyId: propertyId,
      ),
    );
  }
}
