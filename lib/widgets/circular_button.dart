import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final Widget leading;
  final Color backgroundColor;
  final Color textColor;
  const CircularButton({
    required this.onPressed,
    required this.title,
    required this.leading,
    required this.backgroundColor,
    required this.textColor,
    key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: mediaQuery.width * 0.8,
      height: 60,
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(60),
        ),
        onTap: onPressed,
        child: Card(
          color: backgroundColor,
          elevation: 3,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(60),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                leading,
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
