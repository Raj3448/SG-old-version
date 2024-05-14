import 'package:hive/hive.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/setup_hive_boxes.dart';

class UserDetailsCache {
  Future<void> saveUserDetails(User user) async {
    final box = Hive.box<User>(USER_DETAILS_BOX_NAME);
    await box.put(USER_DETAILS_BOX_KEY, user);
  }

  Future<User?> getUserDetails() async {
    final box = Hive.box<User>(USER_DETAILS_BOX_NAME);
    return box.get(USER_DETAILS_BOX_KEY);
  }
}