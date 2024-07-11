import 'package:hive/hive.dart';
import 'package:silver_genie/feature/home/model/master_data_model.dart';
import 'package:silver_genie/setup_hive_boxes.dart';

class MasterdDateCache {
  final box = Hive.box<MasterDataModel>(MASTER_DATA_BOX_NAME);
  Future<void> storeData({required MasterDataModel masterDataModel}) async {
    await box.put(MASTER_DATA_BOX_KEY, masterDataModel);
  }

  MasterDataModel? getData() {
    return box.get(MASTER_DATA_BOX_KEY);
  }

  bool isEmpty() {
    return box.isEmpty;
  }

  Future<void> clear() async {
    await box.delete(MASTER_DATA_BOX_KEY);
  }
}