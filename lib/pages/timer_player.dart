import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time_minder/database/db_calendar.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/models/list_jobs.dart';
import 'package:time_minder/services/logic_timer.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/services/notif.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:time_minder/widgets/common/bottom_navbar.dart';
import 'package:time_minder/widgets/common/on_back_button.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class CombinedTimerPage extends StatefulWidget {
  final int id;

  const CombinedTimerPage({super.key, required this.id});

  @override
  State<CombinedTimerPage> createState() => _CombinedTimerPageState();
}

class _CombinedTimerPageState extends State<CombinedTimerPage> {
  final _cDController = CountDownController();
  final _player = AudioPlayer();
  late Future<List<Map<String, dynamic>>> _dataFuture;
  late List<ListJobs> _jobsTimer;
  late int _currentJobIndex;
  late String _title;
  late String _description;
  late int _timer;
  late int _rest;
  late int _interval;
  bool isStarted = false;
  late int sum;
  late DateTime endTime;
  DateTime? pauseTime;
  var pauseCount = 0;
  var istirahatCount = 0;

  void _pauseOrResume() {
    setState(() {
      if (_cDController.isPaused) {
        pauseCount += DateTime.now().difference(pauseTime!).inSeconds;
        pauseTime = null;
        _player.play(AssetSource('sounds/resume.wav'));
        _cDController.resume();
        _showNotification('Timer dilanjutkan');
      } else {
        pauseTime = DateTime.now();
        _player.play(AssetSource('sounds/pause.wav'));
        _cDController.pause();
        _showNotification('Timer dihentikan');
      }
    });
  }

  void _clearJobs() {
    setState(() {
      _currentJobIndex = 0;
      _cDController.restart(
          duration: _jobsTimer[_currentJobIndex].duration * 60);
      _showNotification('Timer Selesai');
      _player.play(AssetSource('sounds/nothing.wav'));
    });
  }

  int findIntervalLoop(int interval) {
    return interval * 2 + 1;
  }

  void addData() async {
    final elapsed = (_timer * 60) -
        (endTime
            .difference(DateTime.now().subtract(Duration(seconds: pauseCount)))
            .inSeconds) -
        (_rest * 60 * istirahatCount);
    final completed = elapsed >= ((_timer * 60) + (_rest * 60 * istirahatCount)) ? 1 : 0;

    await DBCalendar.createData(
      _title,
      _description,
      (_timer * 60),
      elapsed,
      completed,
      DateTime.now().toIso8601String(),
    );
  }

  @override
  void initState() {
    super.initState();
    Notif.initialize(flutterLocalNotificationsPlugin);
    _dataFuture = SQLHelper.getSingleData(widget.id);
    _currentJobIndex = 0;
    _title = '';
    _description = '';
    _timer = 0;
    _rest = 0;
    _interval = 0;
    _jobsTimer = [];
    _cDController.pause();
    _initVariable();
  }

  void _initVariable() async {
    await _dataFuture.then((value) {
      final data = value.isNotEmpty ? value[0] : {};
      setState(() {
        _title = data['title'] ?? '';
        _description = data['description'] ?? '';
        _timer = data['timer'] ?? 0;
        _rest = data['rest'] ?? 0;
        _interval = data['interval'] ?? 0;
        final newJobs = TimerJobs(
          title: _title,
          description: _description,
          timer: _timer,
          rest: _rest,
          interval: _interval,
        );
        _jobsTimer = newJobs.getAllMode(_timer, _rest, _interval);
        sum = ((_timer + (_rest * _interval)) * 60);
      });
    });
    endTime = DateTime.now().add(Duration(seconds: (_timer * 60)));
  }

  Future<void> _queueTimerJob() async {
    setState(() {
      if (_currentJobIndex < _jobsTimer.length - 1) {
        if (_cDController.isPaused) {
          pauseCount += DateTime.now().difference(pauseTime!).inSeconds;
          pauseTime = null;
        }
        _cDController.restart(
            duration: _jobsTimer[++_currentJobIndex].duration);
        if (_jobsTimer[_currentJobIndex].type == 'ISTIRAHAT') {
          istirahatCount++;
          _player.play(AssetSource('sounds/start.wav'));
          _showNotification("Waktunya Istirahat");
        }
        if (_jobsTimer[_currentJobIndex].type == 'FOKUS') {
          _player.play(AssetSource('sounds/end.wav'));
          _showNotification("Istirahat Selesai");
        }
      } else {
        _player.play(AssetSource('sounds/end.wav'));
        _showNotification("Timer Selesai");
        _cDController.pause();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NavbarBottom(),
          ),
        );
        addData();
      }
    });
  }

  Color getColorRing() {
    if (_cDController.isPaused ||
        _jobsTimer[_currentJobIndex].type == 'ISTIRAHAT') {
      return red;
    } else {
      return ripeMango;
    }
  }

  Color getColor() {
    if (_cDController.isPaused ||
        _jobsTimer[_currentJobIndex].type == 'ISTIRAHAT') {
      return offRed;
    } else {
      return offYellow;
    }
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
            ),
          ),
          title: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                _title,
                style: const TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w600,
                  color: cetaceanBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _description,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: cetaceanBlue,
                ),
              ),
              const SizedBox(height: 10),
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: getColor(),
                            border: Border.all(
                              color: getColorRing(),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _jobsTimer[_currentJobIndex].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 20,
                              color: cetaceanBlue,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07),
                        CircularCountDownTimer(
                            duration: _jobsTimer[_currentJobIndex].duration,
                            initialDuration: 0,
                            controller: _cDController,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.5,
                            ringColor: ring,
                            fillColor: getColorRing(),
                            fillGradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [getColorRing(), offOrange],
                            ),
                            strokeWidth: 20.0,
                            textStyle: const TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            isReverse: true,
                            isReverseAnimation: false,
                            isTimerTextShown: true,
                            onStart: () {
                              _player.play(AssetSource('sounds/start.wav'));
                              _showNotification("Timer dimulai");
                            },
                            onComplete: () => _queueTimerJob()),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        _jobsTimer[_currentJobIndex].type == 'ISTIRAHAT'
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            decoration: BoxDecoration(
                                              color: offBlue,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _pauseOrResume,
                                            child: SvgPicture.asset(
                                              _cDController.isPaused
                                                  ? "assets/images/play.svg"
                                                  : "assets/images/pause.svg",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              color: blueJeans,
                                            ),
                                          ),
                                        ],
                                      ),
                                      isStarted
                                          ? const Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0),
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
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0),
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
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2),
                                  Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            decoration: BoxDecoration(
                                              color: offBlue,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _showPopup();
                                            },
                                            icon: SvgPicture.asset(
                                              "assets/images/check.svg",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              color: blueJeans,
                                            ),
                                            color: blueJeans,
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                      ),
                                      const Text(
                                        "Finish",
                                        style: TextStyle(
                                            fontFamily: 'Nunito',
                                            color: cetaceanBlue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buttonConfirm() async {
    _clearJobs();
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
}
