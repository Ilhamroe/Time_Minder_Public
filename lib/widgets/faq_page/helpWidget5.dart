import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/widgets/faq_page/helpWidget1.dart';
import 'package:time_minder/utils/colors.dart';

class HelpFive extends StatelessWidget {
  const HelpFive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pureWhite,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: const EdgeInsets.only(left: 19).w,
            icon: SvgPicture.asset(
              "assets/images/button_back.svg",
              width: 28,
              height: 28,
            )),
        title: Text(
          "Fitur Detail Timer dan Kalender",
          style: TextStyle(
            fontFamily: 'Nunito_bold',
            fontSize: MediaQuery.of(context).size.width * 0.0525,
          ),
        ),
        centerTitle: true,
        backgroundColor: pureWhite,
        surfaceTintColor: pureWhite,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.0175,
              ),
              Row(
                children: [
                  Flexible(
                      child: Text(
                    "Apa itu fitur detail timer dan kalender?",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.0425,
                        fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              const CustomSpace(),
              const HelpContent(
                  desc:
                      "Fitur “Detail Timer” dan “Kalender” merupakan fitur baru yang ada pada aplikasi TimeMinder, fitur ini memungkinkan kamu untuk melihat informasi lebih lanjut tentang Timer yang telah kamu jalankan pada hari tersebut."),
              const BigSpace(),
              const BigSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
