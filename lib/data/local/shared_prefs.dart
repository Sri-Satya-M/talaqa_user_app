import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const String token = "token";
  static const String schoolType = "schoolType";
  static const String districtId = "districtId";
  static const String district = "district";
  static const String userId = "userId";
  static const String fullName = "fullName";
  static const String schoolName = "schoolName";
  static const String schoolAddress = "schoolAddress";
  static const String lat = "lat";
  static const String long = "long";
  static const String totalStudents = "totalStudents";
  static const String noOfClassrooms = "noOfClassrooms";
  static const String boyStudents = "boyStudents";
  static const String girlStudents = "girlStudents";
  static const String sanctionedTeachers = "sanctionedTeachers";
  static const String workingTeachers = "workingTeachers";
  static const String crtTeachers = "crtTeachers";
  static const String email = "email";
  static const String phone = "phone";
  static const String avatar = "avatar";
  static const String brightness = "brightness";

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

  static Future<bool> setSchoolType(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(schoolType, value);
  }

  static Future<String?> getSchoolType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(schoolType);
  }

  static Future<bool> setDistrictId(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(districtId, value);
  }

  static Future<int?> getDistrictId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(districtId);
  }

  static Future<bool> setDistrict(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(district, value);
  }

  static Future<String?> getDistrict() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(district);
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

  static Future<bool> setTotalStudents(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(totalStudents, value);
  }

  static Future<int?> getTotalStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(totalStudents);
  }

  static Future<bool> setNoOfClassrooms(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(noOfClassrooms, value);
  }

  static Future<int?> getNoOfClassrooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(noOfClassrooms);
  }

  static Future<bool> setBoyStudents(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(boyStudents, value);
  }

  static Future<int?> getBoyStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(boyStudents);
  }

  static Future<bool> setGirlStudents(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(girlStudents, value);
  }

  static Future<int?> getGirlStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(girlStudents);
  }

  static Future<bool> setSanctionedTeachers(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(sanctionedTeachers, value);
  }

  static Future<int?> getSanctionedTeachers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(sanctionedTeachers);
  }

  static Future<bool> setWorkingTeachers(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(workingTeachers, value);
  }

  static Future<int?> getWorkingTeachers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(workingTeachers);
  }

  static Future<bool> setCrtTeachers(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(crtTeachers, value);
  }

  static Future<int?> getCrtTeachers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(crtTeachers);
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
}
