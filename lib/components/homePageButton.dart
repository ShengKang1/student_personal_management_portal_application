import 'package:flutter/material.dart';

class homePageButton extends StatelessWidget {
  final String imageAsset;
  final String buttonName;
  final Function()? onTap;

  const homePageButton(
      {super.key,
      required this.imageAsset,
      required this.buttonName,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    double mobilescreenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: mobilescreenHeight * 0.025),
        child: Container(
          margin: EdgeInsets.only(top: mobilescreenHeight * 0.025),
          padding: EdgeInsets.all(mobilescreenHeight * 0.015),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset(imageAsset,
                width: mobilescreenHeight * 0.025,
                height: mobilescreenHeight * 0.025),
            Expanded(
                child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: mobilescreenHeight * 0.025),
              child: Text(
                buttonName,
                style: TextStyle(fontSize: mobilescreenHeight * 0.018),
              ),
            )),
            Image.asset('images/Arrow Left Icon.png',
                width: mobilescreenHeight * 0.025,
                height: mobilescreenHeight * 0.025),
          ]),
        ),
      ),
    );
  }
}
