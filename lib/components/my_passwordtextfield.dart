import 'package:flutter/material.dart';

class MyPasswordTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final Function(bool)? onPressed;

  const MyPasswordTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.onPressed});

  @override
  State<MyPasswordTextField> createState() => _MyPasswordTextFieldState();
}

class _MyPasswordTextFieldState extends State<MyPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
          left: mobilescreenHeight * 0.03,
          right: mobilescreenHeight * 0.03,
          bottom: mobilescreenHeight * 0.015),
      child: TextField(
        style: TextStyle(fontSize: mobilescreenHeight * 0.02),
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black38),
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: widget.hintText,
          fillColor: Colors.grey[100],
          filled: true,
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
    );
  }
}
