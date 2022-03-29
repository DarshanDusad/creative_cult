import 'package:creative_cult/helpers/constants.dart';
import 'package:flutter/material.dart';
import '../models/event_entry.dart';

class EventEntryTile extends StatefulWidget {
  final EventEntry eventEntry;
  const EventEntryTile(
    this.eventEntry, {
    Key? key,
  }) : super(key: key);

  @override
  State<EventEntryTile> createState() => _EventEntryTileState();
}

class _EventEntryTileState extends State<EventEntryTile> {
  Future<void> giveMarks() async {}

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "assets/images/359168.jpg",
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const Text(
                "Marks:    ",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 18,
                ),
              ),
              Text(
                widget.eventEntry.marks.toString(),
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "SAVE",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 18,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Slider(
            activeColor: primaryColor,
            inactiveColor: primaryColor.withOpacity(0.4),
            value: widget.eventEntry.marks.toDouble(),
            min: 0,
            max: 100,
            onChanged: (double val) {
              setState(() {
                widget.eventEntry.marks = val.toInt();
              });
            },
          )
        ],
      ),
    );
  }
}
