import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlertData extends StatefulWidget {
  const AlertData({Key? key}) : super(key: key);

  @override
  _AlertDataState createState() => _AlertDataState();
}

class _AlertDataState extends State<AlertData> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      title: const Text(
        "Data tidak lengkap",
        style: TextStyle(
          fontFamily: 'Nunito',
        ),
      ),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: screenSize.height * 0.2.h,
              child: SvgPicture.asset(
                'assets/images/confirm_popup.svg',
              ),
            ),
            Text(
              'Nama Timer, Deskripsi, dan Waktu harus diisi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            "OK",
            style: TextStyle(
              fontFamily: 'Nunito',
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
