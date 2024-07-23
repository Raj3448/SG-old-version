import 'package:hive/hive.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/setup_hive_boxes.dart';

class UserDetailsCache {
  final box = Hive.box<User>(USER_DETAILS_BOX_NAME);
  Future<void> saveUserDetails(User user) async {
    await box.put(USER_DETAILS_BOX_KEY, user);
  }

  Future<User?> getUserDetails() async {
    return box.get(USER_DETAILS_BOX_KEY);
  }

  Future<void> clearUserDetails() async {
    await box.delete(USER_DETAILS_BOX_KEY);
  }
}
