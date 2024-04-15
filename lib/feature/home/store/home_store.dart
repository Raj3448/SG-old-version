// ignore_for_file: library_private_types_in_public_api, use_setters_to_change_properties, lines_longer_than_80_chars

import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/home/model/family_model.dart';

part 'home_store.g.dart';

class HomeScreenStore = _HomeScreenStore with _$HomeScreenStore;

abstract class _HomeScreenStore with Store {
  @observable
  ObservableList<FamilyMember> familyMembers = ObservableList.of([
    FamilyMember(name: 'Varun Nair', imagePath: ''),
    FamilyMember(name: 'Shalini Nair', imagePath: '', isActive: false),
  ]);

  @observable
  int selectedIndex = 0;

  @action
  void selectAvatar(int index) {
    selectedIndex = index;
  }
}
