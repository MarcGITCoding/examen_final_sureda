import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _preferences;

  static String _user = '';
  static String _pass = '';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String get user {
    return _preferences.getString('user') ?? _user;
  }

  static String get pass {
    return _preferences.getString('pass') ?? _pass;
  }

  static bool get preferencesSaved {
    return _preferences.getBool('savePreferences') ?? false;
  }

  static set user(String user) {
    _user = user;
    _preferences.setString('user', user);
  }

  static set pass(String pass) {
    _pass = pass;
    _preferences.setString('pass', pass);
  }

  static set preferencesSaved(bool value) {
    _preferences.setBool('savePreferences', value);
  }
}
