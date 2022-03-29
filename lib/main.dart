import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import './screens/home_screen.dart';
import './screens/authentication_screen.dart';
import './screens/event_screen.dart';
import './screens/request_screen.dart';
import './screens/create_event_screen.dart';
import 'providers/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Data(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Creative Cult',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: SharedPreferences.getInstance().then(
            (value) => value.getString("cache"),
          ),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 150,
                  ),
                ),
              );
            }
            if (snap.hasData) {
              return const HomeScreen();
            }
            return const AuthenticationScreen();
          },
        ),
        routes: {
          HomeScreen.route: (ctx) => const HomeScreen(),
          AuthenticationScreen.route: (ctx) => const AuthenticationScreen(),
          EventScreen.route: (ctx) => const EventScreen(),
          RequestScreen.route: (ctx) => const RequestScreen(),
          CreateEventScreen.route: (ctx) => const CreateEventScreen(),
        },
      ),
    );
  }
}
