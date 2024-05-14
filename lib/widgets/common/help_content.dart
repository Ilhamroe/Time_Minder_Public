import 'package:flutter/material.dart';

class HelpContent extends StatefulWidget {
  final String desc;
  const HelpContent({super.key, required this.desc});

  @override
  State<HelpContent> createState() => _HelpContentState();
}

class _HelpContentState extends State<HelpContent> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\u2022",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.0375,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Flexible(
              child: Text(
                widget.desc,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: screenSize.width * 0.0375,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        )
      ],
    );
  }
}

class HelpContentRight extends StatefulWidget {
  final String desc;
  const HelpContentRight({super.key, required this.desc});

  @override
  State<HelpContentRight> createState() => _HelpContentRightState();
}

class _HelpContentRightState extends State<HelpContentRight> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Flexible(
              child: Text(
                widget.desc,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: screenSize.width * 0.0375,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Text(
              "\u2022",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.0375,
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        )
      ],
    );
  }
}
