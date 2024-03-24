import 'package:mobx/mobx.dart';
part 'members_store.g.dart';

class MembersStore = _MembersStoreBase with _$MembersStore;

abstract class _MembersStoreBase with Store {
  @observable
  bool isFetching = true;

  @observable
  bool dataAvailable = true;

  @action
  void disableFetching() {
    isFetching = false;
  }
}
