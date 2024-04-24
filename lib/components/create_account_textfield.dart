import 'package:flutter/material.dart';

class createAccountTextfield extends StatelessWidget {
  final controller;
  final String labelText;
  final String hintText;

  const createAccountTextfield(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: mobilescreenHeight * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Student ID Text
          Text(
            labelText,
            style: TextStyle(fontSize: mobilescreenHeight * 0.021),
          ),
          //Student ID Text Field
          TextField(
            controller: controller,
            style: TextStyle(fontSize: mobilescreenHeight * 0.02),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                  color: Colors.black26, fontSize: mobilescreenHeight * 0.02),
              isDense: true, // Reduces the vertical padding
              contentPadding: EdgeInsets.symmetric(
                  vertical: mobilescreenHeight * 0.015, horizontal: 0.0),
              fillColor: Colors.transparent,
              filled: true,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.black38), // Black line when not focused
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.black), // Black line when focused
              ),
            ),
          ),
        ],
      ),
    );
  }
}
