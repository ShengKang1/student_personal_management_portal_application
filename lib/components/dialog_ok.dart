import 'package:flutter/material.dart';

class Dialog_ok extends StatelessWidget {
  final String title;
  final String content;

  const Dialog_ok({Key? key, required this.title, required this.content})
      : super(key: key);

  void show(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: mobilescreenHeight * 0.025),
          ),
          content: Text(
            content,
            style: TextStyle(fontSize: mobilescreenHeight * 0.018),
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(fontSize: mobilescreenHeight * 0.018),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Your actual widget content here
  }
}

// Example usage:
// DialogOk(title: 'Title', content: 'Content').show(context);
