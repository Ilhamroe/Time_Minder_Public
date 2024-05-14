import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/database/db_calendar.dart';
import 'package:time_minder/utils/colors.dart';

class ResultTimer extends StatefulWidget {
  const ResultTimer({super.key});

  @override
  State<ResultTimer> createState() => _ResultTimerState();
}

class _ResultTimerState extends State<ResultTimer> {
  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0).r,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: DBCalendar.getSingleDate(_focusedDay),
        builder: (context, snapshot) {
          pureWhite;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dataList = snapshot.data!;
            if (dataList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/cat_setting.svg",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0).r,
                      child: const Text(
                        'Ayo tambahkan timer sesuai keinginanmu!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8.0).r,
                shrinkWrap: true,
                itemCount: dataList.length,
                itemBuilder: (context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 13.0).r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0).r,
                      color: offOrange,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 19.0).r,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          screenSize.width * 0.04,
                        ).r,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10).r,
                          color: heliotrope,
                          child: SvgPicture.asset(
                            'assets/images/cat1.svg',
                            height: 30.h,
                          ),
                        ),
                      ),
                      title: Text(
                        dataList[index]['title'],
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontWeight: FontWeight.w900,
                          fontSize: 14.sp,
                        ),
                      ),
                      subtitle: Text(
                        dataList[index]['description'],
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      trailing: (dataList[index]['elapsed'] ==
                              dataList[index]['timer'])
                          ? Image.asset(
                              "assets/images/vector.png",
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${_formatTime(dataList[index]['elapsed'])}",
                                  style: TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                    color: cetaceanBlue,
                                  ),
                                ),
                                Text(
                                  " / ${_formatTime(dataList[index]['timer'])}",
                                  style: TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.sp,
                                    color: cetaceanBlue,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

String _formatTime(int time) {
  if (time >= 3600) {
    int jam = time ~/ 3600;
    return '${jam}h';
  } else if (time >= 60) {
    int minutes = time ~/ 60;
    return '${minutes}m';
  } else {
    return '${time}s';
  }
}
