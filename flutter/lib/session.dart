import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _secure = FlutterSecureStorage();
final _prefs = SharedPreferencesAsync();

/// A secret belongs in the secure store (Android Keystore / iOS Keychain; on
/// the web, encrypted in the browser), never in SQLite or the preferences.
/// Week 4 puts the real sign-in token here; tonight a placeholder shows where
/// it goes and that it survives a restart.
final tokenProvider = FutureProvider<String>((ref) async {
  final saved = await _secure.read(key: 'field.token');
  if (saved != null) return saved;
  final token = 'placeholder-${DateTime.now().microsecondsSinceEpoch}';
  await _secure.write(key: 'field.token', value: token);
  return token;
});

/// Preferences are not secret and not data: a small key–value store is enough.
Future<String> lastTab() async => await _prefs.getString('field.lastTab') ?? '/map';
Future<void> saveLastTab(String path) => _prefs.setString('field.lastTab', path);

/// The network link: wifi, mobile, none… (it says nothing about whether the
/// internet answers — week 5 learns to ask the server).
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) async* {
  final connectivity = Connectivity();
  yield await connectivity.checkConnectivity();
  yield* connectivity.onConnectivityChanged;
});