import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginCredentials(String id, String pass, String cUser) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('id', id);
  await prefs.setString('pass', pass);
  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('cUser', cUser);
}

Future<void> removeLoginCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('id');
  await prefs.remove('pass');
  await prefs.setBool('isLoggedIn', false);
}
