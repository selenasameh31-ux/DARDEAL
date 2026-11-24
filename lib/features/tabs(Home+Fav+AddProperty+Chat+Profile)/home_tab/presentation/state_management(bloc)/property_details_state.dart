import '../../data/models/property_details_model.dart';
import '../../data/models/home_property_model.dart';

abstract class PropertyDetailsState {
  const PropertyDetailsState();
}

class PropertyDetailsInitial extends PropertyDetailsState {}

class PropertyDetailsLoading extends PropertyDetailsState {}

class PropertyDetailsLoaded extends PropertyDetailsState {
  final PropertyDetailsModel property;
  final List<HomePropertyModel> similarProperties;

  const PropertyDetailsLoaded({
    required this.property,
    required this.similarProperties,
  });
}

class PropertyDetailsError extends PropertyDetailsState {
  final String message;

  const PropertyDetailsError(this.message);
}
