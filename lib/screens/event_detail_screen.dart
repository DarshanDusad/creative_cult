import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/event_entry.dart';
import '../helpers/constants.dart';
import '../widgets/event_entry_tile.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  const EventDetailScreen(
    this.event, {
    Key? key,
  }) : super(key: key);
  static const route = "/event-detail-screen";
  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isLoading = true;
  List entries = [];
  Future<void> fetchEventDetails() async {
    var uri = Uri.parse(endpoint + "show_event_details");
    var body = {
      "event_id": widget.event.id,
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

      entries = (json.decode(response.body) as List)
          .map((data) => EventEntry.fromJSON(data))
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
    fetchEventDetails();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CircularProgressIndicator(
        color: primaryColor,
      ),
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
          title: Text(
            widget.event.name,
            style: const TextStyle(
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
              return EventEntryTile(entries[i]);
            },
            itemCount: entries.length,
          ),
        ),
      ),
    );
  }
}
