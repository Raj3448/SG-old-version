// ignore_for_file: library_private_types_in_public_api

import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/feature/onboarding/models/master_data_model.dart';
import 'package:silver_genie/feature/onboarding/service/master_service.dart';
part 'master_store.g.dart';

class MasterStore = _MasterStoreBase with _$MasterStore;

abstract class _MasterStoreBase with Store {
  _MasterStoreBase(this.masterDataService);

  final MasterDataService masterDataService;

  @observable
  Either<Failure, MasterDataModel>? masterData;

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchMasterData() async {
    isLoading = true;
    try {
      masterData = await masterDataService.getMasterData();
    } finally {
      isLoading = false;
    }
  }
}
