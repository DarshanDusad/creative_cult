import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/data.dart';
import '../helpers/constants.dart';
import '../models/event.dart';
import '../widgets/event_tile.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);
  static const route = "/event-screen";

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool isLoading = true;
  List events = [];
  Future<void> fetchEvents() async {
    var currentUser = Provider.of<Data>(context, listen: false).currentUser;
    var uri = Uri.parse(endpoint + "show_attended_events");
    var body = {
      "user_id": currentUser!.id,
    };
    http.Response response;
    try {
      response = await http.post(
        uri,
        encoding: Encoding.getByName("utf-8"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );
      events = (json.decode(response.body) as List)
          .map((data) => Event.fromJSON(data))
          .toList();
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(
        content: Text(
          error.toString(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            color: primaryColor,
          ),
        ),
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () {},
          textColor: Colors.red,
        ),
        backgroundColor: Colors.red[100],
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(
        color: primaryColor,
      ),
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: primaryColor,
          title: const Text(
            'Events',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
          ),
          elevation: 5,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          child: ListView.builder(
            itemBuilder: (ctx, i) {
              return EventTile(events[i]);
            },
            itemCount: events.length,
          ),
        ),
      ),
    );
  }
}
