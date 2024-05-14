import 'package:hive/hive.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';


class UserDetailsAdapter extends TypeAdapter<UserDetails> {
  @override
  final int typeId = 0;

  @override
  UserDetails read(BinaryReader reader) {
    return UserDetails.fromJson(reader.readMap() as Map<String, dynamic>);
  }

  @override
  void write(BinaryWriter writer, UserDetails obj) {
    writer.writeMap(obj.toJson());
  }
}
class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 1;

  @override
  Address read(BinaryReader reader) {
    return Address.fromJson(reader.readMap() as Map<String, dynamic>);
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer.writeMap(obj.toJson());
  }
}
