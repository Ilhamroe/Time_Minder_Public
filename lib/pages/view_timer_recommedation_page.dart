import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/database/db_calendar.dart';
import 'package:time_minder/models/list_timer.dart';
import 'package:time_minder/services/notif.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/common/bottom_navbar.dart';
import 'package:time_minder/widgets/common/on_back_button.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class TimerView extends StatefulWidget {
  final int timerIndex;

  const TimerView({Key? key, required this.timerIndex}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerState();
}

class _TimerState extends State<TimerView> {
  late Timer _timer;
  late int timeInSec;
  late String _waktuMentah;
  late String _judul;
  late String _deskripsi;
  late int _jam;
  late int _menit;
  late int _detik;
  bool isStarted = false;
  late List<Map<String, dynamic>> allData = [];
  bool isLoading = false;
  bool isSoundPlayed = false;
  final player = AudioPlayer();
  late CountDownController _controller;
  late DateTime endTime;
  DateTime? pauseTime;
  var pauseCount = 0;

  void refreshData() async {
    setState(() {
      isLoading = true;
    });
    final data = await DBCalendar.getAllData();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  void addData() async {
    final elapsed = (timeInSec) -
        (endTime
            .difference(DateTime.now().subtract(Duration(seconds: pauseCount)))
            .inSeconds);
    final completed = elapsed >= (timeInSec) ? 1 : 0;

    await DBCalendar.createData(
      _judul,
      _deskripsi,
      timeInSec,
      elapsed,
      completed,
      DateTime.now().toIso8601String(),
    );
  }

  @override
  void initState() {
    super.initState();
    _getDataByID();
    _convertTimeInSec(context, _jam, _menit, _detik);
    _controller = CountDownController();
    endTime = DateTime.now().add(Duration(seconds: timeInSec));
    Notif.initialize(flutterLocalNotificationsPlugin);
    player.onPlayerComplete.listen((event) {
      setState(() {
        isSoundPlayed = false;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: pureWhite,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _showPopup();
            },
            icon: SvgPicture.asset(
              "assets/images/button_back.svg",
              width: 30.w,
              height: 30.h,
              color: cetaceanBlue,
            ),
          ),
          title: Column(
            children: [
              SizedBox(height: 20.h),
              Text(
                _judul,
                style: const TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w600,
                  color: cetaceanBlue,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                _deskripsi,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: pureWhite,
          toolbarHeight: 80.h,
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: pureWhite,
            ),
            width: screenSize.width,
            height: screenSize.height,
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.1.w,
              vertical: screenSize.height * 0.1,
            ).r,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10).w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10).r,
                      color: offYellow,
                      border: Border.all(
                        color: ripeMango,
                        width: 1.w,
                      ),
                    ),
                    child: Text(
                      "FOKUS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontSize: 20.sp,
                        color: cetaceanBlue,
                      ),
                    ),
                  ),
                  CircularCountDownTimer(
                    duration: timeInSec,
                    initialDuration: 0,
                    width: screenSize.width * 0.5.w,
                    height: screenSize.height * 0.4.h,
                    controller: _controller,
                    ringColor: ring,
                    fillColor: _controller.isPaused ? red : ripeMango,
                    fillGradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        _controller.isPaused ? red : ripeMango,
                        offOrange
                      ],
                    ),
                    strokeWidth: 20.0,
                    isReverse: true,
                    isReverseAnimation: false,
                    strokeCap: StrokeCap.round,
                    autoStart: true,
                    textStyle: TextStyle(
                      fontSize: screenSize.width * 0.1.sp,
                      color: _controller.isPaused ? red : cetaceanBlue,
                      fontWeight: FontWeight.bold,
                    ),
                    onComplete: () => complete(),
                    onStart: () {
                      startTimer();
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: screenSize.width * 0.15.w,
                                height:screenSize.width * 0.15.h,
                                decoration: BoxDecoration(
                                  color: offBlue,
                                  borderRadius: BorderRadius.circular(20).r,
                                ),
                              ),
                              GestureDetector(
                                onTap: isStarted ? resumeTimer : pauseTimer,
                                child: SvgPicture.asset(
                                  isStarted
                                      ? "assets/images/play.svg"
                                      : "assets/images/pause.svg",
                                  width:
                                      screenSize.width * 0.07.w,
                                  height:
                                      screenSize.width * 0.07.h,
                                  color: blueJeans,
                                ),
                              ),
                            ],
                          ),
                          isStarted
                              ? Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 8.0).r,
                                    ),
                                    const Text(
                                      "Resume",
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: cetaceanBlue),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 8.0).r,
                                    ),
                                    const Text(
                                      "Pause",
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: cetaceanBlue),
                                    ),
                                  ],
                                )
                        ],
                      ),
                      SizedBox(width: screenSize.width * 0.2.w),
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: screenSize.width * 0.15.w,
                                height:screenSize.width * 0.15.h,
                                decoration: BoxDecoration(
                                  color: offBlue,
                                  borderRadius: BorderRadius.circular(20).r,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showPopup();
                                },
                                icon: SvgPicture.asset(
                                  "assets/images/check.svg",
                                  width: screenSize.width * 0.07.w,
                                  height: screenSize.width * 0.07.h,
                                  color: blueJeans,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0).r,
                          ),
                          const Text(
                            "Finish",
                            style: TextStyle(
                                fontFamily: 'Nunito', color: cetaceanBlue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getDataByID() {
    _timer = Timerlist[widget.timerIndex];
    _waktuMentah = _timer.time;
    _judul = _timer.title;
    _deskripsi = _timer.description;
    _parseWaktuMentah(_waktuMentah);
  }

  void _parseWaktuMentah(String time) {
    List<String> bagian = time.split(':');
    _jam = int.parse(bagian[0]);
    _menit = int.parse(bagian[1]);
    _detik = int.parse(bagian[2]);
  }

  void _convertTimeInSec(BuildContext context, jam, menit, detik) {
    setState(() {
      timeInSec = jam * 3600 + menit * 60 + detik;
    });
  }

  void _showPopup() {
    final screenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SizedBox(
            width: screenSize.width * 0.68.w,
            height: screenSize.height * 0.42.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: screenSize.height * 0.2.h,
                  child: SvgPicture.asset(
                    'assets/images/confirm_popup.svg',
                    fit: BoxFit.contain,
                    width: screenSize.width * 0.2.w,
                    height: screenSize.width * 0.2.h,
                  ),
                ),
                Text(
                  "Kembali ke Beranda,",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 20.0.h),
                Text(
                  "Apakah Anda yakin?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 21.sp,
                  ),
                ),
                SizedBox(height: 20.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0).r,
                        color: halfGrey,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Tidak",
                          style: TextStyle(color: offGrey),
                        ),
                      ),
                    ),
                    SizedBox(width: 30.w),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0).r,
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
      },
    );
  }

  void startTimer() async {
    _showNotification("Timer dimulai");
    player.play(AssetSource("sounds/start.wav"));
  }

  void resumeTimer() async {
    pauseCount += DateTime.now().difference(pauseTime!).inSeconds;
    pauseTime = null;
    setState(() {
      _controller.resume();
      isStarted = false;
      _showNotification("Timer dilanjutkan");
    });

    await player.play(AssetSource("sounds/resume.wav"));
    isSoundPlayed = true;
  }

  void pauseTimer() async {
    pauseTime = DateTime.now();
    setState(() {
      _controller.pause();
      isStarted = true;
      _showNotification("Timer dijeda");
    });

    await player.play(AssetSource("sounds/pause.wav"));
    isSoundPlayed = false;
  }

  Future<void> complete() async {
    setState(() {
      addData();
      _showNotification('Timer selesai');
    });

    await player.play(AssetSource("sounds/end.wav"));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NavbarBottom(),
      ),
    );
  }

  void _showNotification(String message) {
    Notif.showBigTextNotification(
      title: "TimeMinder",
      body: message,
      fln: flutterLocalNotificationsPlugin,
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const OnBackButton();
      },
    );
    return exitApp ?? false;
  }

  Future<void> buttonConfirm() async {
    if (pauseTime != null) {
      pauseCount += DateTime.now().difference(pauseTime!).inSeconds;
    }
    setState(() {
      _showNotification("Timer dihentikan");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NavbarBottom(),
        ),
      );
      addData();
    });
  }
}
