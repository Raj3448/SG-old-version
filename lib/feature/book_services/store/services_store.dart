// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'services_store.g.dart';

class ServicesStore = _ServicesStoreBase with _$ServicesStore;

abstract class _ServicesStoreBase with Store {
  @observable
  bool paymentEnabled = false;

  @observable
  bool detailsEnabled = true;

  @observable
  bool bookingDetailEnabled = false;
}
