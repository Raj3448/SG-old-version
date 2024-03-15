import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.dev')
abstract class Env {
  @EnviedField(varName: 'SERVER_URL', obfuscate: true)
  static String serverUrl = _Env.serverUrl;
}
