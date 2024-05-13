import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
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
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                shrinkWrap: true,
                itemCount: dataList.length,
                itemBuilder: (context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 13.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: offOrange,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 19.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          color: heliotrope,
                          child: SvgPicture.asset(
                            'assets/images/cat1.svg',
                            height: 30,
                          ),
                        ),
                      ),
                      title: Text(
                        dataList[index]['title'],
                        style: const TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        dataList[index]['description'],
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
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
                                  style: const TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: cetaceanBlue,
                                  ),
                                ),
                                Text(
                                  " / ${_formatTime(dataList[index]['timer'])}",
                                  style: const TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
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
