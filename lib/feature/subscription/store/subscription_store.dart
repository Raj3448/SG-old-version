import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/subscription/model/subscription_member_model.dart';
part 'subscription_store.g.dart';

class SubscriptionStore = _SubscriptionStoreBase with _$SubscriptionStore;

abstract class _SubscriptionStoreBase with Store {
  @observable
  List<SubscriptionMemberModel> subscriptionMemberList = [
    SubscriptionMemberModel(name: 'Varun Nair', relation: 'Father', age: 53, plan: 'SG + Wellness 1 month', planEndsDate: "11/04/2024", status: 'Active'),
    SubscriptionMemberModel(name: 'Naya Nair', relation: 'Mother', age: 46, plan: 'SG + Wellness 1 month', planEndsDate: "11/04/2024", status: 'Active'),
    SubscriptionMemberModel(name: 'Olivia Nair', relation: 'Sister', age: 18, plan: 'SG + Wellness 1 month', planEndsDate: "11/04/2024", status: 'Active'),
    SubscriptionMemberModel(name: 'Olivia Nair', relation: 'Sister', age: 18, plan: 'SG + Wellness 1 month', planEndsDate: "11/04/2024", status: 'Active'),
    SubscriptionMemberModel(name: 'Varun Nair', relation: 'Father', age: 53, plan: 'SG + Wellness 1 month', planEndsDate: "11/04/2024", status: 'Active'),
    SubscriptionMemberModel(name: 'Naya Nair', relation: 'Mother', age: 46, plan: 'SG + Wellness 1 month', planEndsDate: "11/04/2024", status: 'Active'),
  ];
}