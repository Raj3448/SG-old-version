import 'package:hive/hive.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';


class UserDetailsAdapter extends TypeAdapter<UserDetails> {
  @override
  final int typeId = 0; // Unique adapter identifier

  @override
  UserDetails read(BinaryReader reader) {
    return UserDetails.fromJson(reader.readMap() as Map<String, dynamic>);
  }

  @override
  void write(BinaryWriter writer, UserDetails obj) {
    writer.writeMap(obj.toJson());
  }
}