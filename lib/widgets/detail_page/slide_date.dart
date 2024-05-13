import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_minder/utils/colors.dart';

class SlideDate extends StatefulWidget {
  const SlideDate({super.key});

  @override
  State<SlideDate> createState() => _SlideDateState();
}

class _SlideDateState extends State<SlideDate> {
  DateTime selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: _focusedDay,
      onDateChange: (selectedDate) {
        setState(() {
          selectedDay = selectedDate;
          _focusedDay = selectedDate;
        });
      },
      locale: "id_id",
      timeLineProps: EasyTimeLineProps(
        hPadding: 4.8.h,
        separatorPadding: 5.5.r,
      ),
      headerProps: const EasyHeaderProps(
        showHeader: false,
      ),
      activeColor: cetaceanBlue,
      dayProps: EasyDayProps(
        todayHighlightStyle: TodayHighlightStyle.withBorder,
        todayHighlightColor: cetaceanBlue,
        borderColor: cetaceanBlue,
        dayStructure: DayStructure.dayStrDayNum,
        width: 35.w,
        height: 41.h,
      ),
    );
  }
}
