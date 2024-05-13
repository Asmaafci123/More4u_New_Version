import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/constants.dart';

 loadEnvFile(String path) async {
  DotEnv instance = DotEnv();
  await instance.load(fileName: path);
  env=instance.env;
}