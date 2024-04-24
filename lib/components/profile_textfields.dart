import 'package:flutter/material.dart';

class profileTextField extends StatelessWidget {
  final controller;
  final bool enabled;
  final bool obscureText;
  final String data;
  final String label;

  const profileTextField(
      {super.key,
      required this.controller,
      required this.enabled,
      required this.obscureText,
      required this.data,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              width: double.infinity,
              child: Text(
                label,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          TextField(
            enabled: enabled,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black38),
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: data,
              fillColor: Colors.grey[200],
              filled: true,
            ),
          ),
        ],
      ),
    );
  }
}
