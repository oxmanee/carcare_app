import 'package:shared_preferences/shared_preferences.dart';

class manageToken {
  save(String token) async {
    final prefes = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefes.setString(key, value);
  }

  read() async {
    final prefes = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefes.getString(key) ?? 0;
    return value;
  }
}
