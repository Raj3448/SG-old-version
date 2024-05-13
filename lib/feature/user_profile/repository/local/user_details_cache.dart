import 'package:hive/hive.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/setup_hive_boxes.dart';

class UserDetailsCache {
  Future<void> saveUserDetails(UserDetails userDetails) async {
    final box = Hive.box<UserDetails>('user_details');
    await box.put(USER_DETAILS_BOX_KEY, userDetails);
  }

  Future<UserDetails?> getUserDetails() async {
    final box = Hive.box<UserDetails>('user_details');
    return box.get(USER_DETAILS_BOX_KEY);
  }
}