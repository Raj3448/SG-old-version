import 'package:silver_genie/feature/onboarding/models/benefits_model.dart';
import 'package:silver_genie/feature/onboarding/models/gender_model.dart';
import 'package:silver_genie/feature/onboarding/models/relations_model.dart';
import 'package:silver_genie/feature/onboarding/models/subscription_type_model.dart';

class MasterDataModel {
  MasterDataModel({
    required this.genders,
    required this.relations,
    required this.subscriptions,
    required this.benefits,
  });

  factory MasterDataModel.fromJson(Map<String, dynamic> json) {
    return MasterDataModel(
      genders: (json['genders'] as List<dynamic>)
          .map((e) => Gender.fromJson(e as Map<String, dynamic>))
          .toList(),
      relations: (json['relations'] as List<dynamic>)
          .map((e) => Relations.fromJson(e as Map<String, dynamic>))
          .toList(),
      subscriptions: (json['subscriptions'] as List<dynamic>)
          .map((e) => SubscriptionType.fromJson(e as Map<String, dynamic>))
          .toList(),
      benefits: (json['benefits'] as List<dynamic>)
          .map((e) => Benefits.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<Gender> genders;
  final List<Relations> relations;
  final List<SubscriptionType> subscriptions;
  final List<Benefits> benefits;
}
