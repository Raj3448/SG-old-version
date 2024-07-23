// ignore_for_file: inference_failure_on_function_invocation

import 'package:hive/hive.dart';
import 'package:silver_genie/setup_hive_boxes.dart';

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

  bool hasToken() {
    return box.containsKey(JWT_TOKEN_KEY);
  }
}
