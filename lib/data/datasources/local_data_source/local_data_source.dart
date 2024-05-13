
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  cacheAppLanguage(int localeCode);
  int? getAppLanguage();
}

const APP_LANGUAGE='APP_LANGUAGE';

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  cacheAppLanguage(int localeCode) {
    return sharedPreferences.setInt(APP_LANGUAGE, localeCode);
  }

  @override
  int? getAppLanguage() {
    return sharedPreferences.getInt(APP_LANGUAGE);
  }
}