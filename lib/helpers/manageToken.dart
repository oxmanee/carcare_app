import 'package:shared_preferences/shared_preferences.dart';

class manageToken {
  save(String username, String fname, String lname, String address, String tel,
      String token) async {
    final prefes = await SharedPreferences.getInstance();
    final keyUser = 'user';
    final valueUser = username;
    final keyFname = 'fname';
    final valueFname = fname;
    final keyLname = 'lname';
    final valueLname = lname;
    final keyAddress = 'address';
    final valueAdress = address;
    final keyTel = 'tel';
    final valueTel = tel;
    final keyToken = 'token';
    final valueToken = token;

    prefes.setString(keyUser, valueUser);
    prefes.setString(keyFname, valueFname);
    prefes.setString(keyLname, valueLname);
    prefes.setString(keyAddress, valueAdress);
    prefes.setString(keyTel, valueTel);
    prefes.setString(keyToken, valueToken);
  }

  readUser() async {
    final prefes = await SharedPreferences.getInstance();
    final key = 'user';
    final value = prefes.getString(key) ?? 0;
    return value;
  }

  readFname() async {
    final prefes = await SharedPreferences.getInstance();
    final key = 'fname';
    final value = prefes.getString(key) ?? 0;
    return value;
  }

  readLname() async {
    final prefes = await SharedPreferences.getInstance();
    final key = 'lname';
    final value = prefes.getString(key) ?? 0;
    return value;
  }

  readAddress() async {
    final prefes = await SharedPreferences.getInstance();
    final key = 'address';
    final value = prefes.getString(key) ?? 0;
    return value;
  }

  readTel() async {
    final prefes = await SharedPreferences.getInstance();
    final key = 'tel';
    final value = prefes.getString(key) ?? 0;
    return value;
  }

  readToken() async {
    final prefes = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefes.getString(key) ?? 0;
    return value;
  }
}
