import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/constants.dart';
import '../helpers/http_functions.dart';
import '../helpers/exceptions.dart';
import '../screens/home_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);
  static const route = "authentication-screen";

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _isSignUp = false;

//Store data locally
  Future<void> onLogin(Map<String, dynamic> response) async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    await ref.setString("cache", jsonEncode(response));
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      additionalSignupFields: [
        UserFormField(
          keyName: "username",
          displayName: "Username",
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid username";
            }
            return null;
          },
          icon: const Icon(Icons.person),
        )
      ],
      hideForgotPasswordButton: true,
      userValidator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter an email address";
        }
        bool emailValid = RegExp(
          r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
        ).hasMatch(value);

        if (!emailValid) {
          return "Please enter a valid email address";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value == null || value.isEmpty || value.length < 8) {
          return "Please enter a password of atleast 8 characters";
        }
        return null;
      },
      messages: LoginMessages(
        confirmPasswordError: "Passwords do not match",
        userHint: "Email Address",
        loginButton: "LOGIN",
        signupButton: "SIGN UP",
        additionalSignUpFormDescription: "Hey! What should we call you?",
        additionalSignUpSubmitButton: "DONE",
        signUpSuccess: "You have been registered! Login to continue",
      ),
      theme: LoginTheme(
        primaryColor: primaryColor,
        accentColor: primaryColor,
        inputTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 2,
          ),
          hintStyle: const TextStyle(
            fontFamily: "Inter",
            fontSize: 22,
            color: Color(0xff9597A1),
          ),
          floatingLabelStyle: const TextStyle(
            fontFamily: "Inter",
            fontSize: 22,
            color: Color(0xff9597A1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
        ),
        titleStyle: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 32,
          color: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.grey[200],
          elevation: 25,
        ),
        bodyStyle: const TextStyle(
          fontFamily: "Inter",
          fontSize: 15,
        ),
        textFieldStyle: const TextStyle(
          fontFamily: "Inter",
          fontSize: 15,
        ),
      ),
      title: "CreativeCult",
      onSubmitAnimationCompleted: () {
        if (_isSignUp) {
          Navigator.of(context)
              .pushReplacementNamed(AuthenticationScreen.route);
        } else {
          Navigator.of(context).pushReplacementNamed(HomeScreen.route);
        }
      },
      onSignup: (data) async {
        _isSignUp = true;
        Map<String, dynamic> responseData;
        var url = endpoint + "register";
        var body = {
          "name": data.additionalSignupData!["username"],
          "email": data.name,
          "password": data.password,
        };
        try {
          responseData = await postFunc(
            url: url,
            body: jsonEncode(body),
          );
          if (responseData["id"] == 0) {
            throw CustomException(responseData["message"]["email"][0]);
          }
        } catch (error) {
          return Future.value(error.toString());
        }
        return Future.value(null);
      },
      onLogin: (data) async {
        _isSignUp = false;
        Map<String, dynamic> responseData;
        var url = endpoint + "login";
        var body = {
          "email": data.name,
          "password": data.password,
        };
        try {
          responseData = await postFunc(
            url: url,
            body: jsonEncode(body),
          );
          print(responseData);
          if (responseData["id"] == 0) {
            throw CustomException(responseData["message"]);
          }
        } catch (error) {
          return Future.value(error.toString());
        }
        onLogin(responseData);
        return Future.value(null);
      },
      onRecoverPassword: (data) {},
    );
  }
}
