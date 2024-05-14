// import 'dart:async';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/material.dart';
// import 'package:time_minder/database/db_helper.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
// import 'package:time_minder/services/notif.dart';
// import 'package:time_minder/utils/colors.dart';
// import 'package:time_minder/widgets/common/bottom_navbar.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// class ViewListTimerPage extends StatefulWidget {
//   final Map<String, dynamic> data;
//   const ViewListTimerPage({Key? key, required this.data}) : super(key: key);

//   @override
//   State<ViewListTimerPage> createState() => _ViewListTimerPageState();
// }

// class _ViewListTimerPageState extends State<ViewListTimerPage> {
//   bool isRestTime = false;
//   int currentTimerValue = 0;
//   bool _isTimerRunning = false;
//   bool statusSwitch = false;
//   bool hideContainer = true;
//   bool isSoundPlayed = false;
//   bool isLoading = false;
//   late List<Map<String, dynamic>> allData = [];
//   late CountDownController _controller;
//   List<String> modeList = [];
//   final player = AudioPlayer();
//   late Timer _timer;
//   Map<String, Timer> scheduledNotifications = {};
//   late Map<String, int> modeMap;

//   int get inTimeMinutes => widget.data['timer'];
//   int get inRestMinutes => widget.data['rest'] ?? 0;
//   int get interval => widget.data['interval'] ?? 1;
//   int get inTimeSeconds => inTimeMinutes * 60;
//   int get inRestSeconds => inRestMinutes * 60;

//   Map<String, dynamic> allMode(
//       int inTimeMinutes, int inRestMinutes, int interval) {
//     int inTimeSeconds = inTimeMinutes * 60;
//     int inRestSeconds = inRestMinutes * 60;

//     int focusTime = inTimeSeconds ~/ (interval + 1);
//     int restTime = inRestSeconds;

//     Map<String, dynamic> modeMap = {};
//     Color color;

//     // Total waktu fokus dan waktu istirahat
//     int totalFocusTime = 0;
//     int totalRestTime = 0;

//     for (int i = 0; i < interval; i++) {
//       modeMap['workDuration${i + 1}'] = focusTime;
//       modeMap['restDuration${i + 1}'] = restTime;

//       if (i % 2 == 0) {
//         color = ripeMango;
//         totalFocusTime +=
//             focusTime; // Menambahkan waktu fokus ke total waktu fokus
//       } else {
//         color = red;
//         totalRestTime +=
//             restTime; // Menambahkan waktu istirahat ke total waktu istirahat
//       }
//       modeMap['color${i + 1}'] = color;
//     }

//     modeMap['workDuration${interval + 1}'] = focusTime;
//     modeMap['color${interval + 1}'] = null;

//     // Menambahkan waktu fokus untuk interval terakhir ke total waktu fokus
//     totalFocusTime += focusTime;

//     int totalDurationInMinutes = totalFocusTime + totalRestTime;

//     return {
//       'modeMap': modeMap,
//       'totalFocusTime': totalFocusTime,
//       'totalRestTime': totalRestTime,
//       'totalDurationInMinutes': totalDurationInMinutes
//     };
//   }

// // // Memanggil fungsi allMode untuk mendapatkan data mode
// //   Map<String, dynamic> modeData =
// //       allMode(inTimeMinutes, inRestMinutes, interval);
// //   int totalDurationInMinutes = modeData['totalDurationInMinutes'];

//   int get inTimeBreak {
//     if (inRestMinutes == 0 && interval == 1) {
//       return inTimeSeconds;
//     } else if (inRestMinutes > 0 && interval == 1) {
//       return inTimeSeconds + inRestSeconds;
//     } else if (inRestMinutes > 0 && interval > 1) {
//       return inTimeSeconds + (inRestSeconds * interval);
//     } else {
//       return inTimeSeconds;
//     }
//   }

//   // Map<String, int> getAllMode(
//   //     int inTimeMinutes, int inRestMinutes, int interval) {
//   //   int inTimeSeconds = inTimeMinutes * 60;
//   //   int inRestSeconds = inRestMinutes * 60;

//   //   int workDuration = inTimeSeconds ~/ (interval + 2);
//   //   int restDuration = inRestSeconds;

//   //   Map<String, int> modeMap = {};
//   //   for (int i = 0; i < interval; i++) {
//   //     modeMap['workDuration${i + 1}'] = workDuration;
//   //     modeMap['restDuration${i + 1}'] = restDuration;
//   //   }

//   //   int remainingWorkDuration = inTimeSeconds - (workDuration * interval);
//   //   modeMap['workDuration${interval + 1}'] = remainingWorkDuration;

//   //   return modeMap;
//   // }

//   void startTimer() async {
//     player.play(AssetSource('sounds/start.wav'));
//     _showNotification("Timer dimulai");
//     isSoundPlayed = true;
//     // for (int i = 0; i < interval; i++) {
//     //   int workDuration = getAllMode(
//     //       inTimeMinutes!, inRestMinutes!, interval)['workDuration${i + 1}']!;
//     //   int restDuration = getAllMode(
//     //       inTimeMinutes!, inRestMinutes!, interval)['restDuration${i + 1}']!;
//     //   scheduleNotification(
//     //       Duration(seconds: workDuration), "Waktunya Istirahat", false);
//     //   scheduleNotification(Duration(seconds: workDuration + restDuration),
//     //       "Istirahat Selesai", true);
//     // }
//   }

//   void resumeTimer() async {
//     setState(() {
//       _controller.resume();
//       _isTimerRunning = false;
//       _showNotification("Timer dilanjutkan");
//     });

//     try {
//       await player.play(AssetSource("sounds/resume.wav"));
//       isSoundPlayed = true;
//     } catch (e) {
//       print("Error playing sound: $e");
//     }
//   }

//   void pauseTimer() async {
//     setState(() {
//       _controller.pause();
//       _isTimerRunning = true;
//       _showNotification("Timer dijeda");
//       cancelAllNotifications();
//     });

//     try {
//       await player.play(AssetSource("sounds/pause.wav"));
//       isSoundPlayed = false;
//     } catch (e) {
//       print("Error playing sound: $e");
//     }
//   }

//   void _startRestTimer() {
//     int focusTime = inTimeSeconds ~/ (interval + 1);
//     int restTime = inRestSeconds;

//     for (int i = 0; i < interval; i++) {
//       print('Start rest timer for interval ${i + 1}');
//       print('Rest time: $restTime seconds');
//     }
//     print('Last focus time (without rest): $focusTime seconds');
//   }

//   void completeTimer() {
//     setState(() {
//       _showNotification('Timer selesai');
//       player.play(AssetSource("sounds/end.wav"));
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const NavbarBottom(),
//         ),
//       );
//       cancelAllNotifications();
//     });
//   }

//   Future<void> buttonConfirm() async {
//     setState(() {
//       _showNotification("Timer dihentikan");
//       cancelAllNotifications();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const NavbarBottom(),
//         ),
//       );
//     });
//   }

//   void _showNotification(String message) {
//     Notif.showBigTextNotification(
//       title: "TimeMinder",
//       body: message,
//       fln: flutterLocalNotificationsPlugin,
//     );
//   }

//   void scheduleNotification(
//       Duration duration, String message, bool isEndOfBreak) {
//     Timer timer = Timer(duration, () {
//       _showNotification(message);
//       if (isEndOfBreak) {
//         player.play(AssetSource('sounds/end.wav'));
//       } else {
//         player.play(AssetSource('sounds/start.wav'));
//       }
//     });
//     scheduledNotifications[message] = timer;
//   }

//   void cancelNotification(String message) {
//     Timer? timer = scheduledNotifications[message];
//     if (timer != null) {
//       timer.cancel();
//       scheduledNotifications.remove(message);
//     }
//   }

//   void cancelAllNotifications() {
//     for (Timer timer in scheduledNotifications.values) {
//       timer.cancel();
//     }
//     scheduledNotifications.clear();
//   }

//   Future<void> _refreshData() async {
//     final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
//     setState(() {
//       allData = data;
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _refreshData();
//     cancelAllNotifications();
//     _controller = CountDownController();
//     Notif.initialize(flutterLocalNotificationsPlugin);
//     player.onPlayerComplete.listen((event) {
//       setState(() {
//         isSoundPlayed = false;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> data = widget.data;
//     return WillPopScope(
//       onWillPop: () => _onBackButtonPressed(context),
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               _showPopupModal();
//             },
//             icon: SvgPicture.asset(
//               "assets/images/button_back.svg",
//               width: 30,
//               height: 30,
//               color: cetaceanBlue,
//             ),
//           ),
//           title: Column(
//             children: [
//               const SizedBox(height: 20),
//               Text(
//                 data['title'],
//                 style: const TextStyle(
//                   fontFamily: 'Nunito-Bold',
//                   fontWeight: FontWeight.w600,
//                   color: cetaceanBlue,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 data['description'],
//                 style: const TextStyle(
//                   fontFamily: 'Nunito',
//                   fontSize: 14,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 10),
//             ],
//           ),
//           centerTitle: true,
//           backgroundColor: pureWhite,
//           toolbarHeight: 80,
//         ),
//         body: SafeArea(
//           child: Container(
//             decoration: const BoxDecoration(
//               color: pureWhite,
//             ),
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             padding: EdgeInsets.symmetric(
//               horizontal: MediaQuery.of(context).size.width * 0.1,
//               vertical: MediaQuery.of(context).size.height * 0.1,
//             ),
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   const Text(
//                     "isRestTime ? `Mode Istirahat` | `Mode Fokus`",
//                     style: const TextStyle(
//                       fontFamily: 'Nunito-Bold',
//                       fontSize: 21,
//                       color: Colors.black,
//                     ),
//                   ),
//                   CircularCountDownTimer(
//                     duration: 0,
//                     initialDuration: 0,
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     height: MediaQuery.of(context).size.height * 0.4,
//                     controller: _controller,
//                     ringColor: ring,
//                     fillColor: _controller.isPaused ? red : ripeMango,
//                     fillGradient: LinearGradient(
//                       begin: Alignment.bottomLeft,
//                       end: Alignment.topRight,
//                       colors: _controller.isPaused
//                           ? [red, offOrange]
//                           : [ripeMango, offOrange],
//                     ),
//                     strokeWidth: 20.0,
//                     isReverse: true,
//                     isReverseAnimation: false,
//                     isTimerTextShown: true,
//                     strokeCap: StrokeCap.round,
//                     autoStart: true,
//                     textStyle: TextStyle(
//                       fontSize: MediaQuery.of(context).size.width * 0.1,
//                       color: _controller.isPaused ? red : cetaceanBlue,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     onComplete: () => completeTimer(),
//                     onStart: () {
//                       startTimer();
//                     },
//                   ),
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Column(
//                         children: [
//                           Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Container(
//                                 width: MediaQuery.of(context).size.width * 0.15,
//                                 height:
//                                     MediaQuery.of(context).size.width * 0.15,
//                                 decoration: BoxDecoration(
//                                   color: offBlue,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap:
//                                     _isTimerRunning ? resumeTimer : pauseTimer,
//                                 child: SvgPicture.asset(
//                                   _isTimerRunning
//                                       ? "assets/images/play.svg"
//                                       : "assets/images/pause.svg",
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.07,
//                                   height:
//                                       MediaQuery.of(context).size.width * 0.07,
//                                   color: blueJeans,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           _isTimerRunning
//                               ? const Column(
//                                   children: [
//                                     const Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 8.0),
//                                     ),
//                                     const Text(
//                                       "Resume",
//                                       style: TextStyle(
//                                           fontFamily: 'Nunito',
//                                           color: cetaceanBlue),
//                                     ),
//                                   ],
//                                 )
//                               : const Column(
//                                   children: [
//                                     const Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 8.0),
//                                     ),
//                                     const Text(
//                                       "Pause",
//                                       style: TextStyle(
//                                           fontFamily: 'Nunito',
//                                           color: cetaceanBlue),
//                                     ),
//                                   ],
//                                 )
//                         ],
//                       ),
//                       SizedBox(width: MediaQuery.of(context).size.width * 0.2),
//                       Column(
//                         children: [
//                           Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Container(
//                                 width: MediaQuery.of(context).size.width * 0.15,
//                                 height:
//                                     MediaQuery.of(context).size.width * 0.15,
//                                 decoration: BoxDecoration(
//                                   color: offBlue,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   _showPopupModal();
//                                 },
//                                 icon: SvgPicture.asset(
//                                   "assets/images/check.svg",
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.07,
//                                   height:
//                                       MediaQuery.of(context).size.width * 0.07,
//                                   color: blueJeans,
//                                 ),
//                                 color: blueJeans,
//                               ),
//                             ],
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8.0),
//                           ),
//                           const Text(
//                             "Finish",
//                             style: TextStyle(
//                                 fontFamily: 'Nunito', color: cetaceanBlue),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<bool> _onBackButtonPressed(BuildContext context) async {
//     bool? exitApp = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           surfaceTintColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.68,
//             height: MediaQuery.of(context).size.height * 0.42,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   child: SvgPicture.asset(
//                     'assets/images/confirm_popup.svg',
//                     fit: BoxFit.contain,
//                     width: MediaQuery.of(context).size.width * 0.2,
//                     height: MediaQuery.of(context).size.width * 0.2,
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 const Text(
//                   "Izinkan timer berjalan di latar belakang",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Nunito',
//                     fontSize: 21,
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: halfGrey,
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop(false);
//                         },
//                         child: const Text(
//                           "Tidak",
//                           style: TextStyle(color: offGrey),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 30),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: ripeMango,
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           buttonConfirm();
//                         },
//                         child: const Text(
//                           "Ya",
//                           style: TextStyle(color: offGrey),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//     return exitApp ?? false;
//   }

//   Future<void> _showPopupModal() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.68,
//             height: MediaQuery.of(context).size.height * 0.42,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   child: SvgPicture.asset(
//                     'assets/images/confirm_popup.svg',
//                     fit: BoxFit.contain,
//                     width: MediaQuery.of(context).size.width * 0.2,
//                     height: MediaQuery.of(context).size.width * 0.2,
//                   ),
//                 ),
//                 const Text(
//                   "Kembali ke Beranda,",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Nunito',
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 const Text(
//                   "Apakah Anda yakin?",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Nunito',
//                     fontSize: 21,
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: halfGrey,
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text(
//                           "Tidak",
//                           style: TextStyle(color: offGrey),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 30),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: ripeMango,
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           buttonConfirm();
//                         },
//                         child: const Text(
//                           "Ya",
//                           style: TextStyle(color: offGrey),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
