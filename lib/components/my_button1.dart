import 'package:flutter/material.dart';

class my_button1 extends StatelessWidget {
  final Function()? onTap;
  final String buttonName;
  const my_button1({super.key, required this.buttonName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: mobilescreenHeight * 0.065),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 25, 50, 70),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            buttonName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: mobilescreenHeight * 0.021,
            ),
          ),
        ),
      ),
    );
  }
}
