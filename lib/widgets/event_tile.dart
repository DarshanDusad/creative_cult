import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../screens/event_detail_screen.dart';

class EventTile extends StatelessWidget {
  final Event event;
  const EventTile(
    this.event, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => EventDetailScreen(event),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat("MMMMd").format(
                          event.startTime,
                        ),
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("-"),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        DateFormat("MMMMd").format(
                          event.endTime,
                        ),
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
