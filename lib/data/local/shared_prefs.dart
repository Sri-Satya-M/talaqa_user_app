import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const String token = "token";
  static const String userId = "userId";
  static const String fullName = "fullName";
  static const String schoolAddress = "schoolAddress";
  static const String lat = "lat";
  static const String long = "long";
  static const String email = "email";
  static const String phone = "phone";
  static const String avatar = "avatar";
  static const String brightness = "brightness";
  static const String lang = "language";
  static const String appLang = "app_language";

  static Future<bool> clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  static Future<bool> setBrightness(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(brightness, isDark);
  }

  static Future<bool?> getBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(brightness);
  }

  static Future<bool> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(token, 'Bearer $value');
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(token);
  }

  static Future<bool> setUserId(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(userId, value);
  }

  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userId);
  }

  static Future<bool> setName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(fullName, value);
  }

  static Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(fullName);
  }

  static Future<bool> setSchoolAddress(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(schoolAddress, value);
  }

  static Future<String?> getSchoolAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(schoolAddress);
  }

  static Future<bool> setLat(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(lat, value);
  }

  static Future<String?> getLat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(lat);
  }

  static Future<bool> setLong(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(long, value);
  }

  static Future<String?> getLong() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(long);
  }

  static Future<bool> setEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(email, value);
  }

  static Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(email);
  }

  static Future<bool> setMobile(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(phone, value);
  }

  static Future<String?> getMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(phone);
  }

  static Future<String?> getAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(avatar);
  }

  static Future<List<String>> getSearchList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList('search');
    print('list = $list');
    return list ?? [];
  }

  static Future<bool> setSearch(String query) async {
    var list = await getSearchList();
    if (list.contains(query)) return false;
    list.add(query);
    if (list.length > 3) list.removeAt(0);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(list);
    return prefs.setStringList('search', list);
  }

  static Future<bool?> getAppLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(appLang);
  }

  static Future<bool> setAppLanguage(bool toApp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(appLang, toApp);
  }

  static Future<String?> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(lang);
  }

  static Future<bool> setLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(lang, language);
  }
}
