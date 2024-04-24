import 'package:flutter/material.dart';

class createAccountPasswordTextfield extends StatefulWidget {
  final controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final Function(bool)? onPressed;

  const createAccountPasswordTextfield(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.hintText,
      required this.obscureText,
      required this.onPressed});

  @override
  State<createAccountPasswordTextfield> createState() =>
      _createAccountPasswordTextfieldState();
}

class _createAccountPasswordTextfieldState
    extends State<createAccountPasswordTextfield> {
  bool _obscureText = true;

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
            widget.labelText,
            style: TextStyle(fontSize: mobilescreenHeight * 0.021),
          ),
          //Student ID Text Field
          TextField(
            controller: widget.controller,
            style: TextStyle(fontSize: mobilescreenHeight * 0.02),
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                  color: Colors.black26, fontSize: mobilescreenHeight * 0.02),
              isDense: true, // Reduces the vertical padding
              contentPadding: EdgeInsets.symmetric(
                  vertical: mobilescreenHeight * 0.015, horizontal: 0.0),
              fillColor: Colors.transparent,
              filled: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.black38), // Black line when not focused
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.black), // Black line when focused
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });

                  if (widget.onPressed != null) {
                    widget.onPressed!(_obscureText);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
