import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'SERVER_URL', obfuscate: false)
  static String serverUrl = _Env.serverUrl;
  @EnviedField(varName: 'TELECRM_URL', obfuscate: false)
  static String telecrmUrl = _Env.telecrmUrl;
  @EnviedField(varName: 'TELECRM_TOKEN', obfuscate: false)
  static String telecrmToken = _Env.telecrmToken;
}
