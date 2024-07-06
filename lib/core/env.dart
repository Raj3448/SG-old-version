import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'SERVER_URL', obfuscate: false)
  static String serverUrl = _Env.serverUrl;
}
