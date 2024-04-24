import 'package:flutter/material.dart';

class my_snackbar extends StatelessWidget {
  final String text;
  const my_snackbar({required this.text});

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.white,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Your actual widget content here
  }
}
