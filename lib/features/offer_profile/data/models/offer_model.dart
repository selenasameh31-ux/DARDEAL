import 'package:graduation_project_flutter/core/routing/routes_export.dart';

enum OfferStatus { accepted, pending, deleted }

class OfferModel {
  final String title;
  final String reference;
  final String price;
  final OfferStatus status;
  final List<OfferChip> chips;

  const OfferModel({
    required this.title,
    required this.reference,
    required this.price,
    required this.status,
    required this.chips,
  });

  Color get statusColor {
    switch (status) {
      case OfferStatus.accepted:
        return Colors.green;
      case OfferStatus.pending:
        return LightColors.lightAttentionText;
      case OfferStatus.deleted:
        return Colors.red;
    }
  }
}

class OfferChip {
  final String label;
  final ChipType type;

  const OfferChip({required this.label, required this.type});
}

enum ChipType { success, primary, info, warning, secondary, error, outline }
