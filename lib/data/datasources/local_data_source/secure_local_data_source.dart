import 'package:flutter_secure_storage/flutter_secure_storage.dart';
abstract class SecureStorage{
  Future<void> writeSecureData(String key,String? value);
  Future<String?> readSecureData(String key);
  Future<void> deleteSecureData(String key);
}
class SecureStorageImpl implements SecureStorage
{

  final FlutterSecureStorage storage=const FlutterSecureStorage();
  @override
  Future<void> writeSecureData(String key,String? value)async
  {
    await storage.write(key: key, value: value);
  }
  @override
  Future<String?> readSecureData(String key)async
  {
    String? value = await storage.read(key: key);
    return value;
  }
  @override
  Future<void> deleteSecureData(String key)async
  {
    await storage.delete(key: key);
  }
}