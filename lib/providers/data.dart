import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../helpers/constants.dart';

class Data with ChangeNotifier {
  User? currentUser;

  Future<void> initializeUserFromCache() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    Map<String, dynamic> response =
        jsonDecode(ref.getString("cache").toString());
    currentUser = User.fromJSON(
      response["user"],
      response["session_info"]["token"],
    );
    notifyListeners();
  }

  Future<void> logout() async {
    Map<String, dynamic> responseData;
    var uri = Uri.parse(endpoint + "logout");
    var body = {
      "user_id": currentUser!.id,
    };
    await http.post(
      uri,
      encoding: Encoding.getByName("utf-8"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    SharedPreferences ref = await SharedPreferences.getInstance();
    await ref.clear();
    currentUser = null;
  }
}
