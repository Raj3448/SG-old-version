import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

const TOKEN_BOX_NAME = 'jwt_token_box';
const JWT_TOKEN_KEY = 'JWT_token';
Future<void> setupHiveBox() async {
  var key = Hive.generateSecureKey(); // Generate a secure encryption key
  final storage = const FlutterSecureStorage();
  await storage.write(key: 'hive_key', value: base64UrlEncode(key));
  var encryptedBox = await Hive.openBox(TOKEN_BOX_NAME,
      encryptionCipher: HiveAesCipher(key));
}

class TokenManager {
  
  final box = Hive.box(TOKEN_BOX_NAME);

  Future<void> saveToken(String token) async {
    await box.put(JWT_TOKEN_KEY, token);
  }

  Future<dynamic> getToken() async {
    return box.get(JWT_TOKEN_KEY);
  }

  Future<void> deleteToken() async {
    await box.delete(JWT_TOKEN_KEY);
  }
}
