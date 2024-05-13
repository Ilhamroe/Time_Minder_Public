import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
              width: 30,
              height: 30,
              color: cetaceanBlue,
            ),
          ),
          title: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                _judul,
                style: const TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w600,
                  color: cetaceanBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _deskripsi,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: pureWhite,
          toolbarHeight: 80,
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: pureWhite,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.1,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: offYellow,
                      border: Border.all(
                        color: ripeMango,
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "FOKUS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontSize: 20,
                        color: cetaceanBlue,
                      ),
                    ),
                  ),
                  CircularCountDownTimer(
                    duration: timeInSec,
                    initialDuration: 0,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.4,
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
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                      color: _controller.isPaused ? red : cetaceanBlue,
                      fontWeight: FontWeight.bold,
                    ),
                    onComplete: () => complete(),
                    onStart: () {
                      startTimer();
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.width * 0.15,
                                decoration: BoxDecoration(
                                  color: offBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              GestureDetector(
                                onTap: isStarted ? resumeTimer : pauseTimer,
                                child: SvgPicture.asset(
                                  isStarted
                                      ? "assets/images/play.svg"
                                      : "assets/images/pause.svg",
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                  height:
                                      MediaQuery.of(context).size.width * 0.07,
                                  color: blueJeans,
                                ),
                              ),
                            ],
                          ),
                          isStarted
                              ? const Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                    ),
                                    Text(
                                      "Resume",
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: cetaceanBlue),
                                    ),
                                  ],
                                )
                              : const Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                    ),
                                    Text(
                                      "Pause",
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: cetaceanBlue),
                                    ),
                                  ],
                                )
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.width * 0.15,
                                decoration: BoxDecoration(
                                  color: offBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showPopup();
                                },
                                icon: SvgPicture.asset(
                                  "assets/images/check.svg",
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                  height:
                                      MediaQuery.of(context).size.width * 0.07,
                                  color: blueJeans,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                const Text(
                  "Kembali ke Beranda,",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Apakah Anda yakin?",
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
                          Navigator.of(context).pop();
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
