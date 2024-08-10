import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', useConstantCase: true)
final class Constants {
  @EnviedField(varName: 'APPPLICATION_ID')
  static const String applicationId = _Constants.applicationId;
  @EnviedField(varName: 'API_KEY')
  static const String apiKey = _Constants.apiKey;
  @EnviedField(varName: 'INDEX_NAME')
  static const String indexName = _Constants.indexName;

}
