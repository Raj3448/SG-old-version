import 'package:hive/hive.dart';

const TOKEN_BOX_NAME = 'jwt_token_box';
const JWT_TOKEN_KEY = 'JWT_token';

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
