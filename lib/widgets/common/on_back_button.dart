import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_minder/pages/timer_player.dart';
import 'package:time_minder/services/notif.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/common/bottom_navbar.dart';

class OnBackButton extends StatefulWidget {
  const OnBackButton({super.key});

  @override
  State<OnBackButton> createState() => _OnBackButtonState();
}

class _OnBackButtonState extends State<OnBackButton> {
  void _showNotification(String message) {
    Notif.showBigTextNotification(
      title: "TimeMinder",
      body: message,
      fln: flutterLocalNotificationsPlugin,
    );
  }

  Future<void> buttonConfirm() async {
    setState(() {
      _showNotification("Timer dihentikan");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NavbarBottom(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.68,
        height: MediaQuery.of(context).size.height * 0.42,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: SvgPicture.asset(
                'assets/images/confirm_popup.svg',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Izinkan timer berjalan di latar belakang",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 21,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: halfGrey,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(
                      "Tidak",
                      style: TextStyle(color: offGrey),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: ripeMango,
                  ),
                  child: TextButton(
                    onPressed: () {
                      buttonConfirm();
                    },
                    child: const Text(
                      "Ya",
                      style: TextStyle(color: offGrey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
