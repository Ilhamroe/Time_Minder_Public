import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/utils/colors.dart';

class HelpOne extends StatefulWidget {
  const HelpOne({super.key});

  @override
  State<HelpOne> createState() => _HelpOneState();
}

class _HelpOneState extends State<HelpOne> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> offsetAnimation;
  late AnimationController _controller2;
  late Animation<Offset> offsetAnimation2;

  @override
  void initState() {
    super.initState();
    //kiri-kanan
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    //kanan-kiri
    _controller2 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    offsetAnimation2 = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeIn));
    _controller2.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context){
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
            )),
        title: Text(
          "Menggunakan Fitur Custom Timer",
          style: TextStyle(
            fontFamily: 'Nunito-Bold',
            fontSize: screenSize.width * 0.0525.w,
          ),
        ),
        centerTitle: true,
        backgroundColor: pureWhite,
        surfaceTintColor: pureWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20).w,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenSize.height * 0.0175.h,
              ),
              Row(
                children: [
                  Flexible(
                      child: Text(
                    "Bagaimana saya menambahkan timer dengan custom waktu istirahat?",
                    style: TextStyle(
                        fontSize: screenSize.width * 0.0425.w,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',),
                  )),
                ],
              ),
              const CustomSpace(),
              const HelpContent(
                  desc:
                      "Untuk menambahkan timer, kamu hanya perlu pergi ke tombol plus pada navigation bar yang ada pada bagian bawah aplikasi."),
              Image.asset("assets/images/help1-1.png"),
              const CustomSpace(),
              const HelpContent(
                  desc:
                      "Tekan tombol tersebut maka akan muncul modal dengan beberapa form yang harus kamu isi: "),
              const BigSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideImage(
                    image: "assets/images/help1-2.jpg",
                    offsetAnimation: offsetAnimation,
                    height: 250,
                    // width: 250,
                  ),
                  const Flexible(
                      child: HelpContentRight(
                          desc:
                              "Masukkan nama timer kamu dan deskripsi dari timer tersebut")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: HelpContent(
                        desc: "Masukkan durasi waktu fokus yang kamu mau"),
                  ),
                  SlideImage(
                    image: "assets/images/help1-3.png",
                    offsetAnimation: offsetAnimation2,
                    height: 250,
                    // width: 250,
                  ),
                ],
              ),
              const BigSpace(),
              const HelpContent(
                  desc:
                      "Jika kamu ingin menambahkan waktu istirahat sesuai dengan preferensimu, tekan tombol panah berikut untuk membuka additional option"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/help1-4.png",
                    height: 350,
                  ),
                ],
              ),
              const BigSpace(),
              const HelpContent(
                desc:
                    "Tekan radio button untuk mengaktifkan mode istirahat kemudian masukkan durasi istirahat dan jumlah waktu istirahat yang kamu mau",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/help1-5.png",
                    height: 350,
                  ),
                ],
              ),
              const BigSpace(),
              const HelpContent(
                  desc:
                      "Setelah mengatur durasi fokus dan waktu istirahat, klik “Terapkan” untuk menambahkan ke daftar timermu"),
              const CustomSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/help/help1-6.png"),
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

//widgetssssss

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
                fontSize: screenSize.width * 0.0375.w,
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.02.w,
            ),
            Flexible(
              child: Text(
                widget.desc,
                style: TextStyle(
                  fontSize: screenSize.width * 0.0375.w,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenSize.height * 0.01.h,
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
              width: screenSize.width * 0.03.w,
            ),
            Flexible(
              child: Text(
                widget.desc,
                style: TextStyle(
                  fontSize: screenSize.width * 0.0375.w,
                ),
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.03.w,
            ),
            Text(
              "\u2022",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.0375.w,
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenSize.height * 0.01.h,
        )
      ],
    );
  }
}

class SlideImage extends StatefulWidget {
  final String image;
  // final double width;
  final double height;
  final Animation<Offset> offsetAnimation;
  const SlideImage(
      {super.key,
      required this.image,
      required this.offsetAnimation,
      // required this.width,
      required this.height});

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: SlideTransition(
          position: widget.offsetAnimation,
          child: Image.asset(
            widget.image,
            // width: widget.width,
            height: widget.height,
          )),
    );
  }
}

class CustomSpace extends StatelessWidget {
  const CustomSpace({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height * 0.01.h,
    );
  }
}

class BigSpace extends StatelessWidget {
  const BigSpace({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height * 0.06.h,
    );
  }
}