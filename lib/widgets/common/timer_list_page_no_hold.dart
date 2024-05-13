import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/pages/timer_player.dart';
import 'package:time_minder/utils/colors.dart';


typedef ModalCloseCallback = void Function(int? id);

class ListTimerPageNoHold extends StatefulWidget {
  final bool isSettingPressed;

  const ListTimerPageNoHold({Key? key, required this.isSettingPressed})
      : super(key: key);

  @override
  State<ListTimerPageNoHold> createState() => _ListTimerPageNoHoldState();
}

class _ListTimerPageNoHoldState extends State<ListTimerPageNoHold> {
  int counter = 0;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;

  final TextEditingController _namaTimerController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  late List<Map<String, dynamic>> _allData = [];
  // refresh data
  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      isLoading = false;
    });
  }

  // delete data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Data deleted"),
        duration: Duration(milliseconds: 500),
      ));
    }
    _refreshData();
  }

  void _showModal(ModalCloseCallback onClose, [int? id]) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _namaTimerController.text = existingData['title'];
      _deskripsiController.text = existingData['description'];
      counter = existingData['time'] ?? 0;
      counterBreakTime = existingData['rest'] ?? 0;
      counterInterval = existingData['interval'] ?? 0;
    } else {
      _namaTimerController.text = '';
      _deskripsiController.text = '';
      setState(() {
        counter = 0;
      });
      counterBreakTime = 0;
      counterInterval = 0;
    }

    final newData = await showCupertinoModalPopup(
      context: context,
      builder: (_) => Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          // Modal content
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
              ),
              // child: DisplayModal(id: id),
            ),
          ),
        ],
      ),
    );
    onClose(newData);
    _refreshData();
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void dispose() {
    _namaTimerController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _allData.length,
      itemBuilder: (context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CombinedTimerPage(
                  id: _allData[index]['id'],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 14.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: offOrange,
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 19.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.04,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  color: heliotrope,
                  child: SvgPicture.asset(
                    'assets/images/cat1.svg',
                    height: 30,
                  ),
                ),
              ),
              title: Text(
                _allData[index]['title'],
                style: const TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                _allData[index]['description'],
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              trailing: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    _formatTime(_allData[index]['timer']),
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 9,
                      color: darkGrey,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 7),
                    decoration: BoxDecoration(
                      color: ripeMango,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Mulai",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 8,
                        color: pureWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(int time) {
    int hours = time ~/ 60;
    int minutes = time % 60;
    int seconds = 0;

    String padLeft(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${padLeft(hours)}:${padLeft(minutes)}:${padLeft(seconds)}';
  }
}

