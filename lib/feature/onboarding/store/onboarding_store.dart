// ignore_for_file: avoid_positional_boolean_parameters, library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'onboarding_store.g.dart';

class OnboardingStore = _OnboardingStoreBase with _$OnboardingStore;

abstract class _OnboardingStoreBase with Store {
  _OnboardingStoreBase() {
    _loadPrefs();
  }

  late SharedPreferences _preferences;

  @observable
  bool showOnboarding = true;

  @action
  Future<void> setOnboardingStatus(bool status) async {
    showOnboarding = status;
    await _preferences.setBool('showOnboarding', status);
  }

  Future<void> _loadPrefs() async {
    _preferences = await SharedPreferences.getInstance();
    showOnboarding = _preferences.getBool('showOnboarding') ?? true;
  }
}
