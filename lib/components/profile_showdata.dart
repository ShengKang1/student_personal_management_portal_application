import 'package:flutter/material.dart';

class ProfileData extends StatelessWidget {
  final String textlabel;
  final String userData;

  const ProfileData(
      {super.key, required this.textlabel, required this.userData});

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Wrap(
        // alignment: WrapAlignment.start,
        children: [
          Text(
            textlabel + ": ",
            style: TextStyle(fontSize: mobilescreenHeight * 0.02),
          ),
          Text(
            userData,
            style: TextStyle(fontSize: mobilescreenHeight * 0.02),
          )
        ],
      ),
    );
  }
}
