import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:silver_genie/feature/user_profile/hive_adaptor/user_details_adapter.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

const TOKEN_BOX_NAME = 'jwt_token_box';
const JWT_TOKEN_KEY = 'JWT_token';

const USER_DETAILS_BOX_NAME = 'user_details_box';
const USER_DETAILS_BOX_KEY = 'userDetails_box_key';

const storage = FlutterSecureStorage();

Future<void> setupHiveBox() async {
  await initializeBoxForToken();
  await initializeBoxForUserDetails();
}

Future<void> initializeBoxForUserDetails() async {
  Hive
    ..registerAdapter(UserAdapter())
    ..registerAdapter(AddressAdapter());

  await Hive.openBox<User>(
    USER_DETAILS_BOX_NAME,
    compactionStrategy: (int total, int deleted) => deleted > 2,
  );
}

// Future<void> initializeBoxForUserDetails() async {
//   Hive..registerAdapter(UserAdapter())..registerAdapter(AddressAdapter());
//   String? userDetailsKeyEncoded = await storage.read(key: USER_DETAILS_BOX_KEY);
//   if (userDetailsKeyEncoded == null) {
//     var userDetailsKey = Hive.generateSecureKey();
//     await storage.write(key: USER_DETAILS_BOX_KEY, value: base64UrlEncode(userDetailsKey));
//     userDetailsKeyEncoded = base64UrlEncode(userDetailsKey);
//   } else {
//     userDetailsKeyEncoded = await storage.read(key: USER_DETAILS_BOX_KEY);
//   }
//   var userDetailsKey = base64Url.decode(userDetailsKeyEncoded!);
//   await Hive.openBox<User>(
//     USER_DETAILS_BOX_NAME,
//     encryptionCipher: HiveAesCipher(userDetailsKey),
//     compactionStrategy: (int total, int deleted) => deleted > 20,
//   );
// }

Future<void> initializeBoxForToken() async {
  String? existingKey = await storage.read(key: 'hive_key');
  if (existingKey == null) {
    var newKey = Hive.generateSecureKey();
    await storage.write(key: 'hive_key', value: base64UrlEncode(newKey));
    existingKey = base64UrlEncode(newKey);
  }
  var key = base64Url.decode(existingKey);
  await Hive.openBox(TOKEN_BOX_NAME, encryptionCipher: HiveAesCipher(key));
}
