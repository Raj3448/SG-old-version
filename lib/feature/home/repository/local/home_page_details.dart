import 'package:hive/hive.dart';
import 'package:silver_genie/setup_hive_boxes.dart';

class HomePageComponentDetailscache {
  final box = Hive.box<List<dynamic>>(HOMEPAGE_DETAILS_BOX_NAME);
  Future<void> storeHomePageComponentDetails(
      List<dynamic> componentDetailsList) async {
    await box.put(HOMEPAGE_DETAILS_BOX_Key, componentDetailsList);
  }

  Future<List<dynamic>?> getComponentDetails() async {
    return box.get(HOMEPAGE_DETAILS_BOX_Key);
  }

  bool isEmpty() {
    return box.isEmpty;
  }

  Future<void> clearHomeComponentDetils() async {
    await box.delete(HOMEPAGE_DETAILS_BOX_Key);
  }
}
