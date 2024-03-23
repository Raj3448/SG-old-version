// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'main_store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store {
  @observable
  int currentIndex = 0;

  @observable
  bool isSelected = false;

  @observable
  bool isFetching = true;

  @observable
  bool dataAvailable = true;

  @action
  void disableFetching() {
    isFetching = false;
  }
}
