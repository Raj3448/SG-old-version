// ignore_for_file: inference_failure_on_instance_creation, library_private_types_in_public_api, lines_longer_than_80_chars

import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/subscription/model/subscription_member_model.dart';
part 'subscription_store.g.dart';

class SubscriptionStore = _SubscriptionStoreBase with _$SubscriptionStore;

abstract class _SubscriptionStoreBase with Store {
  @observable
  List<SubscriptionMemberModel> subscriptionMemberList = [
    const SubscriptionMemberModel(
      name: 'Varun Nair',
      relation: 'Father',
      age: 53,
      plan: 'SG + Wellness 1 month',
      planEndsDate: '11/04/2024',
      status: 'Active',
    ),
    const SubscriptionMemberModel(
      name: 'Naya Nair',
      relation: 'Mother',
      age: 46,
      plan: 'SG + Wellness 1 month',
      planEndsDate: '11/04/2024',
      status: 'Active',
    ),
    const SubscriptionMemberModel(
      name: 'Olivia Nair',
      relation: 'Sister',
      age: 18,
      plan: 'SG + Wellness 1 month',
      planEndsDate: '11/04/2024',
      status: 'Active',
    ),
    const SubscriptionMemberModel(
      name: 'Olivia Nair',
      relation: 'Sister',
      age: 18,
      plan: 'SG + Wellness 1 month',
      planEndsDate: '11/04/2024',
      status: 'Active',
    ),
    const SubscriptionMemberModel(
      name: 'Varun Nair',
      relation: 'Father',
      age: 53,
      plan: 'SG + Wellness 1 month',
      planEndsDate: '11/04/2024',
      status: 'Active',
    ),
    const SubscriptionMemberModel(
      name: 'Naya Nair',
      relation: 'Mother',
      age: 46,
      plan: 'SG + Wellness 1 month',
      planEndsDate: '11/04/2024',
      status: 'Active',
    ),
  ];
}
