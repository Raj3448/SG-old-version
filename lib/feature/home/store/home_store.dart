import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/home/model/family_model.dart';

part 'home_store.g.dart';

class HomeScreenStore = _HomeScreenStore with _$HomeScreenStore;

abstract class _HomeScreenStore with Store {
  @observable
  ObservableList<FamilyMember> familyMembers = ObservableList.of([
    FamilyMember(name: 'Varun Nair', imagePath: '',isActive: true),
    FamilyMember(name: 'Shalini Nair', imagePath: '',isActive:false),
    //TODO :Add more family members here as needed
  ]);

  @observable
  int selectedIndex = 0;

  @action
  void selectAvatar(int index) {
    selectedIndex = index;
  }
}

