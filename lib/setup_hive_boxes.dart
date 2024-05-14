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
  Hive..registerAdapter(UserDetailsAdapter())..registerAdapter(AddressAdapter());
  var userDetailsKey = Hive.generateSecureKey(); // Generate a secure encryption key
  
  await storage.write(
      key: USER_DETAILS_BOX_KEY, value: base64UrlEncode(userDetailsKey));
  await Hive.openBox<UserDetails>(
    USER_DETAILS_BOX_NAME,
    encryptionCipher: HiveAesCipher(userDetailsKey),
    compactionStrategy: (int total, int deleted) => deleted > 2,
  );
}

Future<void> initializeBoxForToken() async {
  var key = Hive.generateSecureKey(); // Generate a secure encryption key
  await storage.write(key: 'hive_key', value: base64UrlEncode(key));
  await Hive.openBox(TOKEN_BOX_NAME, encryptionCipher: HiveAesCipher(key));
}