//Helper file to keep all http request functions
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/exceptions.dart';

//Function to perform a get request
Future<Map<String, dynamic>> getFunc({
  required String url,
}) async {
  try {
    var uri = Uri.parse(url);
    var response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "/",
      },
    );
    return jsonDecode(response.body);
  } catch (e) {
    throw CustomException(
        "Unable to connect. Please check your network connection.");
  }
}

//Function to perform a post request
Future<Map<String, dynamic>> postFunc({
  required String url,
  required String body,
}) async {
  http.Response response;
  try {
    var uri = Uri.parse(url);
    response = await http.post(
      uri,
      encoding: Encoding.getByName("utf-8"),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    print(response.body);
  } catch (e) {
    throw CustomException(
        "Unable to connect. Please check your network connection.");
  }
  return jsonDecode(response.body);
}
