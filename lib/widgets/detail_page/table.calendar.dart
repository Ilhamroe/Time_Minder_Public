import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_minder/utils/colors.dart';

class TableCalendarDetail extends StatefulWidget {
  const TableCalendarDetail({super.key});

  @override
  State<TableCalendarDetail> createState() => _TableCalendarDetailState();
}

class _TableCalendarDetailState extends State<TableCalendarDetail> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(2100),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      locale: 'id_ID',
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        markersMaxCount: 1,
        todayDecoration: BoxDecoration(
          color: cetaceanBlue,
          border: Border.all(color: cetaceanBlue),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(color: pureWhite),
        selectedDecoration: BoxDecoration(
          color: offBlue,
          border: Border.all(color: blueJeans),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(color: cetaceanBlue),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
          _selectedDay = focusedDay;
        });
      },
    );
  }
}
