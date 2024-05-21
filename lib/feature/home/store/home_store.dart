// ignore_for_file: library_private_types_in_public_api, use_setters_to_change_properties, lines_longer_than_80_chars

import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/feature/home/model/family_model.dart';
import 'package:silver_genie/feature/home/services/home_services.dart';

part 'home_store.g.dart';

class HomeStore = _HomeScreenStore with _$HomeStore;

abstract class _HomeScreenStore with Store {
  _HomeScreenStore({required this.homeServices});

  final IHomeServices homeServices;

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

  @observable
  Either<Failure, List<dynamic>>? homePageComponentDetailsList;

  @observable
  bool isloading = false;

  Future<void> getHomePageComponentDetails() async {
    isloading = true;
    homePageComponentDetailsList = await homeServices.getHomePageInfo();
    isloading = false;
  }
}
