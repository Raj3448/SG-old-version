import 'package:mobx/mobx.dart';
part 'services_store.g.dart';

class ServicesStore = _ServicesStoreBase with _$ServicesStore;

abstract class _ServicesStoreBase with Store {
  @observable
  bool paymentEnabled = false;

  @observable
  bool detailsEnabled = false;
}
