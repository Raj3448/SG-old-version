import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeScreenStore = _HomeScreenStoreBase with _$HomeScreenStore;

abstract class _HomeScreenStoreBase with Store {
  @observable
  bool isAvatar1Selected = false;

  @action
  void selectAvatar1() {
    isAvatar1Selected = true;
  }

  @action
  void selectAvatar2() {
    isAvatar1Selected = false;
  }
}
