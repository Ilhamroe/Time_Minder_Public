import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/widgets/faq_page/help_widget1.dart';
import 'package:time_minder/utils/colors.dart';

class HelpThree extends StatefulWidget {
  const HelpThree({super.key});

  @override
  State<HelpThree> createState() => _HelpThreeState();
}

class _HelpThreeState extends State<HelpThree>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: pureWhite,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: const EdgeInsets.only(left: 20).w,
            icon: SvgPicture.asset(
              "assets/images/button_back.svg",
              width: 28,
              height: 28,
            )),
        title: Text(
          "Menghapus Timer",
          style: TextStyle(
            fontFamily: 'Nunito_bold',
            fontSize: screenSize.width * 0.0525,
          ),
        ),
        centerTitle: true,
        backgroundColor: pureWhite,
        surfaceTintColor: pureWhite,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenSize.height * 0.0175,
              ),
              Row(
                children: [
                  Flexible(
                      child: Text(
                    "Bagaimana jika saya ingin menghapus timer yang telah saya tambahkan?",
                    style: TextStyle(
                      fontSize: screenSize.width * 0.0425,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                  )),
                ],
              ),
              const CustomSpace(),
               const HelpContent(
                  desc:
                      "Jika kamu ingin menghapus timer yang telah kamu tambahkan sebelumnya, pergi ke menu “Timer” pada navigation bar yang terletak di bagian bawah aplikasi."
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/help/help2-1.png"),
                ],
              ),
              const BigSpace(),
              const HelpContent(
                  desc:
                      "Pada menu ini akan terlihat beberapa timer yang telah kamu tambahkan sebelumnya."),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideImage(
                    image: "assets/images/help/help2-2.png", 
                    offsetAnimation: offsetAnimation, 
                    width: 350, 
                    height: 350
                  ),
                ],
              ),
              const BigSpace(),
               Row(
                children: [
                  const Flexible(
                      child: HelpContent(
                          desc:
                              "Untuk menghapus, tap lama atau hold salah satu timer yang ingin kamu hapus")),
                  Image.asset(
                    "assets/images/help/help2-3.png",
                    height: 200,
                    width: 200,
                  )
                ],
              ),
              const BigSpace(),
              Row(
                children: [
                  Image.asset(
                    "assets/images/help/help2-4.png",
                    height: 200,
                    width: 200,
                  ),
                  const Flexible(
                      child: HelpContentRight(
                          desc:
                              "Kemudian akan muncul icon tempat sampah dibagian atas aplikasi")),
                ],
              ),
              const BigSpace(),
              const HelpContent(
                  desc:
                      "Tekan icon tempat sampah tersebut. Konfirmasi apakah kamu benar-benar akan menghapus timer tersebut"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/help/help2-5.jpg",
                    height: 250,
                    width: 250,
                  )
                ],
              ),
              const CustomSpace(),
              const HelpContent(
                  desc: "Maka timer akan dihapus dari daftar timermu"),
              const BigSpace(),
              const BigSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
