// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:time_minder/database/db_helper.dart';
// import 'package:time_minder/utils/colors.dart';
// import 'package:time_minder/services/notif.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:time_minder/widgets/common/bottom_navbar.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// typedef ModalCloseCallback = void Function(int? id);

// class ModalConfirm extends StatefulWidget {
//   final Function()? onConfirm;

//   const ModalConfirm({Key? key, this.onConfirm}) : super(key: key);

//   @override
//   State<ModalConfirm> createState() => _ModalConfirmState();
// }

// class _ModalConfirmState extends State<ModalConfirm> {
//   late List<Map<String, dynamic>> allData = [];

//   bool isLoading = false;
//   bool statusSwitch = false;
//   final player = AudioPlayer();

//   // refresh data
//   Future<void> _refreshData() async {
//     final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
//     setState(() {
//       allData = data;
//       isLoading = false;
//     });
//   }

//   void _showNotification(String message) {
//     Notif.showBigTextNotification(
//       title: "TimeMinder",
//       body: message,
//       fln: flutterLocalNotificationsPlugin,
//     );
//   }

//   Future<void> buttonConfirm() async {
//     setState(() {
//       _showNotification("Timer dihentikan");
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const NavbarBottom(),
//         ),
//       );
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _refreshData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       content: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.68,
//         height: MediaQuery.of(context).size.height * 0.42,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.2,
//               child: SvgPicture.asset(
//                 'assets/images/confirm_popup.svg',
//                 fit: BoxFit.contain,
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.width * 0.2,
//               ),
//             ),
//             const Text(
//               "Kembali ke Beranda,",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Nunito',
//                 fontSize: 15,
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             const Text(
//               "Apakah Anda yakin?",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Nunito',
//                 fontSize: 21,
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     color: halfGrey,
//                   ),
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text(
//                       "Tidak",
//                       style: TextStyle(color: offGrey),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 30),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     color: ripeMango,
//                   ),
//                   child: TextButton(
//                     onPressed: () {
//                       buttonConfirm();
//                     },
//                     child: const Text(
//                       "Ya",
//                       style: TextStyle(color: offGrey),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
