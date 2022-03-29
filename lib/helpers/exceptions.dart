import 'dart:core';

class CustomException implements Exception {
  String msg = 'An error occured. Please try again later';
  CustomException(this.msg);
  @override
  String toString() {
    return msg;
  }
}
