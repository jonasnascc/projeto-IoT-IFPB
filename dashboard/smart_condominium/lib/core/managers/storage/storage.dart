export 'storage_manager.dart';

class Storage {
  Storage._();
  static final instance = Storage._();

  String userLoginKey = 'userKey';
  String userPasswordKey = 'passwordKey';
}
