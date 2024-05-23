// import 'package:hive/hive.dart';
// import 'package:silver_genie/feature/user_profile/model/user_details.dart';

// class UserAdapter extends TypeAdapter<User> {
//   @override
//   final int typeId = 0;

//   @override
//   User read(BinaryReader reader) {
//     final map = reader.readMap().cast<String, dynamic>();

//     // Cast the address field separately if it exists
//     if (map['address'] != null && map['address'] is Map) {
//       map['address'] = (map['address'] as Map).cast<String, dynamic>();
//     }

//     return User.fromJson(map);
//   }

//   @override
//   void write(BinaryWriter writer, User obj) {
//     writer.writeMap(obj.toJson());
//   }
// }

// class AddressAdapter extends TypeAdapter<Address> {
//   @override
//   final int typeId = 1;

//   @override
//   Address read(BinaryReader reader) {
//     final map = Map<String, dynamic>.from(reader.readMap());
//     return Address.fromJson(map);
//   }

//   @override
//   void write(BinaryWriter writer, Address obj) {
//     writer.writeMap(obj.toJson());
//   }
// }
