import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/pages/timer_player.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:time_minder/widgets/common/providers.dart';

typedef ModalCloseCallback = void Function(int? id);

class ListTimerPageHold extends StatefulWidget {
  final List<Map<String, dynamic>> allData;

  const ListTimerPageHold({Key? key, required this.allData})
      : super(key: key);

  @override
  State<ListTimerPageHold> createState() => _ListTimerPageHoldState();
}

class _ListTimerPageHoldState extends State<ListTimerPageHold> {
  int counter = 0;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;

  final TextEditingController _namaTimerController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // refresh data
  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
    setState(() {
      isLoading = false;
    });
  }

  // delete data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    _refreshData();
  }

  void _showModal(ModalCloseCallback onClose, [int? id]) async {
    if (id != null) {
      final existingData =
          widget.allData.firstWhere((element) => element['id'] == id);
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
  void dispose() {
    _namaTimerController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void updateSelectedItems(List<int> newSelectedItems) {
    final selectedItemsProvider =
        Provider.of<SelectedItemsProvider>(context, listen: false);
    selectedItemsProvider.updateSelectedItems(newSelectedItems);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Consumer<SelectedItemsProvider>(
      builder: (context, selectedItemsProvider, _) {
        final selectedItemsProvider =
            Provider.of<SelectedItemsProvider>(context);
        final selectedItems = selectedItemsProvider.selectedItems;
        final Size screenSize = MediaQuery.of(context).size;
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.allData.length,
          itemBuilder: (context, int index) {
            return GestureDetector(
              onTap: () {
                if (selectedItems.isNotEmpty) {
                  setState(() {
                    if (selectedItems.contains(index)) {
                    selectedItemsProvider.removeFromSelectedItems(index);
                  } else {
                    selectedItemsProvider.addToSelectedItems(index);
                  }
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CombinedTimerPage(
                        id: widget.allData[index]['id'],
                      ),
                    ),
                  );
                }
              },
              onLongPress: () {
                setState(() {
                  if (selectedItems.contains(index)) {
                    selectedItemsProvider.removeFromSelectedItems(index);
                  } else {
                    selectedItemsProvider.addToSelectedItems(index);
                  }
                });
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 14.0).h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0).w,
                      color: offOrange,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 19.0).w,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(screenSize.width * 0.04,).w,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10).w,
                          color: heliotrope,
                          child: SvgPicture.asset(
                            'assets/images/cat1.svg',
                            height: 30.h,
                          ),
                        ),
                      ),
                      title: Text(
                        _allData[index]['title'],
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontWeight: FontWeight.w900,
                          fontSize: 14.sp,
                        ),
                      ),
                      subtitle: Text(
                        _allData[index]['description'],
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      trailing: Column(
                        children: [
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            _formatTime(_allData[index]['timer']),
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.w600,
                              fontSize: 9.sp,
                              color: darkGrey,
                            ),
                          ),
                          SizedBox(
                            height: 5.0.h,
                          ),
                          GestureDetector(
                            onTap: selectedItems.isNotEmpty
                                ? null
                                : () {
                                    Container();
                                  },
                            child: IgnorePointer(
                              ignoring: selectedItems.isNotEmpty,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 7).w,
                                decoration: BoxDecoration(
                                  color: ripeMango,
                                  borderRadius: BorderRadius.circular(5).w,
                                ),
                                child: selectedItems.isNotEmpty
                                    ? Text(
                                        "pilih",
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: screenSize.width * 0.025.w,
                                          color: pureWhite,
                                        ),
                                      )
                                    : Text(
                                        "Mulai",
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: screenSize.width * 0.025.w,
                                          color: pureWhite,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 52.w,
                    top: 62.h,
                    child: Container(
                      width: 21.w,
                      height: 21.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedItems.contains(index)
                            ? ripeMango
                            : Colors.transparent,
                      ),
                      child: selectedItems.contains(index)
                          ? SvgPicture.asset("assets/images/selected_item.svg")
                          : null,
                    ),
                  ),
                ],
              ),
            );
          },
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
