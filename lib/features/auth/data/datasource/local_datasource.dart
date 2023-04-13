import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  void setToken(String token) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('x-auth-token');
  }
}
