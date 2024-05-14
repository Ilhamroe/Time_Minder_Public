import 'package:flutter/material.dart';


class CustomSpace extends StatelessWidget {
  const CustomSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }
}

class BigSpace extends StatelessWidget {
  const BigSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
    );
  }
}
