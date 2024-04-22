import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/onboarding/models/benefits_model.dart';
import 'package:silver_genie/feature/onboarding/models/gender_model.dart';
import 'package:silver_genie/feature/onboarding/models/relations_model.dart';
import 'package:silver_genie/feature/onboarding/models/subscription_model.dart';

abstract class IMasterService {
  Future<List<Gender>> getGenders();
  Future<List<Relations>> getRelations();
  Future<List<SubscriptionType>> getSubscriptions();
  Future<List<Benefits>> getBenefits();
}

class FetchMasterData implements IMasterService {
  @override
  Future<List<Gender>> getGenders() async {
    /*
    final dio = GetIt.I<HttpClient>();
    final response = await dio.get('https://silvergenie.com/api/v1/genders');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Gender> genders = data.map(Gender.fromJson).toList();

      return genders;
    } else {
      throw Exception('Failed to load genders');
    }
    */

    return [
      Gender(id: '0', name: 'Male'),
      Gender(id: '1', name: 'Female'),
      Gender(id: '2', name: 'Others'),
    ];
  }

  @override
  Future<List<Relations>> getRelations() async {
    return [
      Relations(id: 0, name: 'Father', rank: 1, active: true),
      Relations(id: 1, name: 'Mother', rank: 2, active: true),
      Relations(id: 2, name: 'Brother', rank: 3, active: true),
      Relations(id: 3, name: 'Sister', rank: 4, active: true),
      Relations(id: 4, name: 'Uncle', rank: 5, active: true),
      Relations(id: 5, name: 'Aunt', rank: 6, active: true),
    ];
  }

  @override
  Future<List<SubscriptionType>> getSubscriptions() async {
    return [
      SubscriptionType(
        name: 'Convenience Care',
        desc: 'This is Convenience care package',
        benefits: [
          'Easy',
          'Comes at your convenience.',
        ],
      ),
      SubscriptionType(
        name: 'Emergency Care',
        desc: 'This is Emergency care package',
        benefits: [
          'Fast',
          'Comes at your home.',
        ],
      ),
    ];
  }

  @override
  Future<List<Benefits>> getBenefits() async {
    return [];
  }
}
