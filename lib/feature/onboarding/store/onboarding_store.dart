// ignore_for_file: avoid_positional_boolean_parameters, library_private_types_in_public_api, lines_longer_than_80_chars

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'onboarding_store.g.dart';

class OnboardingStore = _OnboardingStoreBase with _$OnboardingStore;

abstract class _OnboardingStoreBase with Store {
  _OnboardingStoreBase({required this.preferences}) {
    init();
  }
  final SharedPreferences preferences;

  @observable
  bool showOnboarding = true;

  @action
  void setOnboardingStatus(bool status) {
    showOnboarding = status;
    preferences.setBool('showOnboarding', status);
  }

  void init() {
    showOnboarding = preferences.getBool('showOnboarding') ?? true;
  }
}
