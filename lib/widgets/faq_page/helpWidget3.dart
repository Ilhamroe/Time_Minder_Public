import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/widgets/faq_page/helpWidget1.dart';
import 'package:time_minder/utils/colors.dart';

class HelpThree extends StatefulWidget {
  const HelpThree({super.key});

  @override
  State<HelpThree> createState() => _HelpThreeState();
}

class _HelpThreeState extends State<HelpThree> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
      _controller= AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this
    );
    offsetAnimation= Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeIn)
    );
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
    return Scaffold(
      backgroundColor: pureWhite,
       appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          
            },
            padding: const EdgeInsets.only(left: 19).w,
          icon: SvgPicture.asset("assets/images/button_back.svg",
          width: 28,
          height: 28,
          )
        ),
        title: Text(
          "Fitur izinkan latar belakang",
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
          horizontal: MediaQuery.of(context).size.width * 0.05
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.0175,),
              Row(
                children: [
                  Flexible(child: Text("Apakah bisa timer dijalankan di latar belakang?", 
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.0425,
                    fontWeight: FontWeight.bold),)),
                ],
              ),
              const CustomSpace(),
              const HelpContent(
                desc: "Timer pada TimeMinder dapat dijalankan di latar belakang, dimana memungkinkan untuk tetap menggunakan perangkat yang kamu pakai untuk melakukan kegiatan lain sambil tetap melacak waktu fokus dan istirahat."
                ),
              const HelpContent(
                desc: "Saat kamu akan keluar dari timer dengan menekan tombol kembali baik menggunakan button navigation atau gesture navigation, pastikan untuk mengaktifkan izin latar belakang saat akan keluar dari aplikasi TimeMinder agar timer dapat tetap berjalan di latar belakang sehingga memastikan fungsi ini berjalan dengan lancar."
                ),
              const CustomSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideImage(
                    image: "assets/images/help/help3-1.png", 
                    offsetAnimation: offsetAnimation, 
                    width: 350, 
                    height: 350
                  ),
                ],
              ),
              const BigSpace(),
              const BigSpace(),
            ],
          ),
        ),
      ),
    );
  }
}