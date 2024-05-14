// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:time_minder/pages/view_list_timer_page.dart';
// import 'package:time_minder/services/notif.dart';
// import 'package:time_minder/utils/colors.dart';
// import 'package:time_minder/widgets/common/bottom_navbar.dart';

// class OnBackButton extends StatefulWidget {
//   const OnBackButton({super.key});

//   @override
//   State<OnBackButton> createState() => _OnBackButtonState();
// }

// class _OnBackButtonState extends State<OnBackButton> {
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
//   Widget build(BuildContext context) {
//     final Size screenSize = MediaQuery.of(context).size;
//     return AlertDialog(
//       surfaceTintColor: Colors.transparent,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0).w,
//       ),
//       content: SizedBox(
//         width: screenSize.width * 0.68.w,
//         height: screenSize.height * 0.42.h,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               height: screenSize.height * 0.2.h,
//               child: SvgPicture.asset(
//                 'assets/images/confirm_popup.svg',
//                 fit: BoxFit.contain,
//                 width: screenSize.width * 0.2.w,
//                 height: screenSize.width * 0.2.h,
//               ),
//             ),
//             SizedBox(height: 20.0.h),
//             Text(
//               "Izinkan timer berjalan di latar belakang",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Nunito',
//                 fontSize: 21.sp,
//               ),
//             ),
//             SizedBox(height: 20.0.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0).w,
//                     color: halfGrey,
//                   ),
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop(false);
//                     },
//                     child: const Text(
//                       "Tidak",
//                       style: TextStyle(color: offGrey),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 30.w),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0).r,
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
