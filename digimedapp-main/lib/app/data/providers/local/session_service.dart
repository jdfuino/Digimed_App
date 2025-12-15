import 'package:digimed/app/domain/models/credentials/credentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const sessionIdKey = 'sessionId';
const accountKey = 'accountId';

const usernameCredential = 'username';
const passwordCredential = 'password';

class SessionService {
  SessionService(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  Future<String?> get sessionId {
    return _secureStorage.read(key: sessionIdKey);
  }

  Future<String?> get accountId {
    return _secureStorage.read(key: accountKey);
  }

  Future<Credential> get credentials async {
    String? username = await _secureStorage.read(key: usernameCredential);
    String? password = await _secureStorage.read(key: passwordCredential);
    return Credential(username: username, password: password);
  }

  Future<void> saveSessionId(String sessionId) {
    return _secureStorage.write(
      key: sessionIdKey,
      value: sessionId,
    );
  }

  Future<void> saveAccountId(String accountId) {
    return _secureStorage.write(
      key: accountKey,
      value: accountId,
    );
  }

  Future<void> saveCredentials(String username, String password) async {
    _secureStorage.write(key: usernameCredential, value: username);
    _secureStorage.write(key: passwordCredential, value: password);
  }

  Future<void> signOut() {
    return _secureStorage.delete(key: sessionIdKey);
  }
}
