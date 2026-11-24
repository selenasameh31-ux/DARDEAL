import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/models/amenities_data.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/models/amenity_model.dart';
import 'package:flutter/material.dart';

void main() {
  print('AVAILABLE COMMUNITY RULES:');
  for (var rule in AmenitiesData.availableCommunityRules) {
    print('ID: "${rule.id}", Name: "${rule.name}"');
  }
}
