import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helpers/constants.dart';
import '../helpers/http_functions.dart';
import '../helpers/exceptions.dart';
import '../widgets/circular_button.dart';
import '../providers/data.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);
  static const route = "/create-event-screen";

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime? startTime;
  DateTime? endTime;
  GlobalKey<FormState> globalKey = GlobalKey();

  Future<void> createEvent() async {
    FocusScope.of(context).unfocus();
    if (globalKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var currentUser = Provider.of<Data>(context, listen: false).currentUser;
      var url = endpoint + "make_new_event";
      var body = {
        "token": currentUser!.token,
        "business": "MAKE_NEW_EVENT",
        "starting_datetime": DateFormat("yyyy-MM-dd").format(startTime!),
        "ending_datetime": DateFormat("yyyy-MM-dd").format(endTime!),
        "event_name": nameController.text,
        "description": descriptionController.text,
      };
      Map<String, dynamic> responseData;
      try {
        responseData = await postFunc(
          url: url,
          body: jsonEncode(body),
        );
        print(responseData);
        if (responseData["id"] == 0) {
          throw CustomException(responseData["message"]["event_name"][0]);
        }
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
      final snackBar = SnackBar(
        content: const Text(
          "Event Created!",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            color: Colors.green,
          ),
        ),
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () {},
          textColor: Colors.green,
        ),
        backgroundColor: Colors.green[100],
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
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
            'Create An Event',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
          ),
          elevation: 5,
        ),
        body: Form(
          key: globalKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 25,
              ),
              child: Column(
                children: [
                  const Text(
                    "Enter event details",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return "Please enter name of the event";
                      }
                      return null;
                    },
                    controller: nameController,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      color: Color(0xff9597A1),
                    ),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: "Event Name",
                      hintStyle: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        color: Color(0xff9597A1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFFE4E7EC),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFFE4E7EC),
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (description) {
                      if (description == null || description.isEmpty) {
                        return "Please enter a short description of the event";
                      }
                      return null;
                    },
                    controller: descriptionController,
                    maxLines: 4,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      color: Color(0xff9597A1),
                    ),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        color: Color(0xff9597A1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFFE4E7EC),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFFE4E7EC),
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (date) {
                            if (date == null || date.isEmpty) {
                              return "Please select a start date";
                            }
                            return null;
                          },
                          controller: startTimeController,
                          enabled: false,
                          style: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 16,
                            color: Color(0xff9597A1),
                          ),
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            hintText: "Start Date",
                            hintStyle: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 16,
                              color: Color(0xff9597A1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFE4E7EC),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFE4E7EC),
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            errorStyle: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () async {
                          DateTime? datetime = await showDatePicker(
                            builder: (ctx, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: primaryColor,
                                  colorScheme: const ColorScheme.light(
                                    primary: primaryColor,
                                  ),
                                  buttonTheme: const ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary,
                                  ),
                                ),
                                child: child ?? Container(),
                              );
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(
                                days: 365,
                              ),
                            ),
                          );
                          if (datetime == null) {
                            return;
                          }
                          setState(() async {
                            startTime = datetime;
                            startTimeController.text =
                                DateFormat.yMMMMd().format(startTime!);
                          });
                        },
                        icon: const Icon(
                          Icons.calendar_today_sharp,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (date) {
                            if (date == null || date.isEmpty) {
                              return "Please select an end date";
                            }
                            if (startTime!.isAfter(endTime!)) {
                              return "Please select an end date after the start date";
                            }
                            return null;
                          },
                          controller: endTimeController,
                          enabled: false,
                          style: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 16,
                            color: Color(0xff9597A1),
                          ),
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            hintText: "End Date",
                            hintStyle: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 16,
                              color: Color(0xff9597A1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFE4E7EC),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFE4E7EC),
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            errorStyle: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () async {
                          DateTime? datetime = await showDatePicker(
                            builder: (ctx, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: primaryColor,
                                  colorScheme: const ColorScheme.light(
                                    primary: primaryColor,
                                  ),
                                  buttonTheme: const ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary,
                                  ),
                                ),
                                child: child ?? Container(),
                              );
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(
                                days: 365,
                              ),
                            ),
                          );
                          if (datetime == null) {
                            return;
                          }
                          setState(() async {
                            endTime = datetime;
                            endTimeController.text =
                                DateFormat.yMMMMd().format(endTime!);
                          });
                        },
                        icon: const Icon(
                          Icons.calendar_today_sharp,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CircularButton(
                    onPressed: createEvent,
                    title: "Create",
                    leading: Container(),
                    backgroundColor: primaryColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
