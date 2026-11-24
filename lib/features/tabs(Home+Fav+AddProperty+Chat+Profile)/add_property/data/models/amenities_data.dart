
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
class AmenitiesData {
  static const List<AmenityModel> availableAmenities = [
    AmenityModel(id: 'balcony', name: 'Balcony', icon: Icons.balcony),
    AmenityModel(id: 'security', name: 'Security', icon: Icons.security),
    AmenityModel(id: 'elevator', name: 'Elevator', icon: Icons.elevator),
    AmenityModel(id: 'maid_room', name: 'Maid Room', icon: Icons.room_service_outlined),
    AmenityModel(id: 'water_meter', name: 'Water Meter', icon: Icons.water_drop_outlined),
    AmenityModel(id: 'pets_allowed', name: 'Pets Allowed', icon: Icons.pets),
    AmenityModel(id: 'swimming_pool', name: 'Swimming Pool', icon: Icons.pool),
    AmenityModel(id: 'landline_phone', name: 'Landline Phone', icon: Icons.phone_outlined),
    AmenityModel(id: 'private_garden', name: 'Private Garden', icon: Icons.yard_outlined),
    AmenityModel(id: 'kids_play_area', name: 'Kids Play Area', icon: Icons.child_care_outlined),
    AmenityModel(id: 'covered_parking', name: 'Covered Parking', icon: Icons.local_parking),
    AmenityModel(id: 'air_conditioning', name: 'Air Conditioning', icon: Icons.ac_unit),
    AmenityModel(id: 'electricity_meter', name: 'Electricity Meter', icon: Icons.bolt_outlined),
    AmenityModel(id: 'natural_gas_meter', name: 'Natural Gas Meter', icon: Icons.gas_meter_outlined),
    AmenityModel(id: 'kitchen_appliances', name: 'Kitchen Appliances', icon: Icons.kitchen_outlined),
  ];

  static const List<AmenityModel> availableCommunityRules = [
    AmenityModel(id: 'no_smoking', name: 'No Smoking', icon: Icons.smoke_free),
    AmenityModel(id: 'no_pets', name: 'No Pets', icon: Icons.pets_outlined),
    AmenityModel(id: 'no_parties', name: 'No Parties', icon: Icons.celebration_outlined),
    AmenityModel(id: 'quiet_hours', name: 'Quiet Hours', icon: Icons.notifications_off_outlined),
    AmenityModel(id: 'males_only', name: 'Males Only', icon: Icons.male),
    AmenityModel(id: 'females_only', name: 'Females Only', icon: Icons.female),
    AmenityModel(id: 'students_only', name: 'Students Only', icon: Icons.school_outlined),
    AmenityModel(id: 'professionals', name: 'Professionals', icon: Icons.business_center_outlined),
    AmenityModel(id: 'no_preference', name: 'No Preference', icon: Icons.groups_outlined),
    AmenityModel(id: 'guests_allowed', name: 'Guests Allowed', icon: Icons.door_front_door_outlined),
    AmenityModel(id: 'long_term_only', name: 'Long Term Only', icon: Icons.schedule_outlined),
  ];

  static const List<AmenityModel> availableNearbyFacilities = [
    AmenityModel(id: 'universities', name: 'Universities', icon: Icons.school),
    AmenityModel(id: 'hospitals', name: 'Hospitals', icon: Icons.local_hospital),
    AmenityModel(id: 'metro_station', name: 'Metro Station', icon: Icons.directions_subway),
    AmenityModel(id: 'shopping_malls', name: 'Shopping Malls', icon: Icons.shopping_bag),
    AmenityModel(id: 'supermarkets', name: 'Supermarkets', icon: Icons.shopping_cart),
    AmenityModel(id: 'mosques', name: 'Mosques', icon: Icons.mosque),
    AmenityModel(id: 'pharmacies', name: 'Pharmacies', icon: Icons.local_pharmacy),
    AmenityModel(id: 'restaurants', name: 'Restaurants & Cafes', icon: Icons.restaurant),
    AmenityModel(id: 'sports_clubs', name: 'Sports Clubs', icon: Icons.sports_soccer),
    AmenityModel(id: 'public_parks', name: 'Public Parks', icon: Icons.park),
    AmenityModel(id: 'schools', name: 'Schools', icon: Icons.school_outlined),
    AmenityModel(id: 'banks', name: 'Banks & ATMs', icon: Icons.account_balance),
  ];
}
