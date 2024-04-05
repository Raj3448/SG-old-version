// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'main_store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store {
  @observable
  int currentIndex = 0;
}