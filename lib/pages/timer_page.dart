import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/common/bottom_navbar.dart';
import 'package:time_minder/widgets/common/providers.dart';
import 'package:time_minder/widgets/common/timer_list_page_hold.dart';
import 'package:time_minder/widgets/common/timer_recommendations_page.dart';
import 'package:provider/provider.dart';
import 'package:time_minder/widgets/modal_timer/add_modal.dart';

final logger = Logger();
typedef ModalCloseCallback = void Function(int? id);

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  late List<Map<String, dynamic>> _allData = [];

  late TabController tabController;
  int counter = 0;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;
  bool isSemuaSelected = true;
  bool isSettingPressed = false;

  final TextEditingController _namaTimerController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  void updateSelectedItems(List<int> newSelectedItems) {
    final selectedItemsProvider =
        Provider.of<SelectedItemsProvider>(context, listen: false);
    selectedItemsProvider.updateSelectedItems(newSelectedItems);
  }

  Future<void> _refreshData() async {
    final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      isLoading = false;
    });
  }

  Future<void> _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    _refreshData();
  }

// Handler untuk delete multiple data by ID
  Future<void> _deleteMultipleData(List<int> ids) async {
    for (int id in ids) {
      await SQLHelper.deleteData(id);
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
      // Jika data baru, reset nilai controller
      _namaTimerController.text = '';
      _deskripsiController.text = '';
      counter = 0;
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
              child: ModalAdd(id: id),
            ),
          ),
        ],
      ),
    );
    onClose(newData);
    _refreshData();
  }

  bool swipeIsInProgress = false;
  bool tapIsBeingExecuted = false;
  int selectedIndex = 0;
  int prevIndex = 1;

  @override
  void initState() {
    super.initState();
    _refreshData();
    tabController =
        TabController(initialIndex: selectedIndex, length: 2, vsync: this);
    tabController.animation?.addListener(() {
      if (!tapIsBeingExecuted &&
          !swipeIsInProgress &&
          (tabController.offset >= 0.5 || tabController.offset <= -0.5)) {
        int newIndex = tabController.offset > 0
            ? tabController.index + 1
            : tabController.index - 1;
        swipeIsInProgress = true;
        prevIndex = selectedIndex;
        setState(() {
          selectedIndex = newIndex;
        });
      } else {
        if (!tapIsBeingExecuted &&
            swipeIsInProgress &&
            ((tabController.offset < 0.5 && tabController.offset > 0) ||
                (tabController.offset > -0.5 && tabController.offset < 0))) {
          swipeIsInProgress = false;
          setState(() {
            selectedIndex = prevIndex;
          });
        }
      }
    });
    tabController.addListener(() {
      swipeIsInProgress = false;
      setState(() {
        selectedIndex = tabController.index;
      });
      if (tapIsBeingExecuted == true) {
        tapIsBeingExecuted = false;
      } else {
        if (tabController.indexIsChanging) {
          tapIsBeingExecuted = true;
        }
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    _namaTimerController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Consumer<SelectedItemsProvider>(
      builder: (context, selectedItemsProvider, _) {
        final selectedItemsProvider =
            Provider.of<SelectedItemsProvider>(context);
        final selectedItems = selectedItemsProvider.selectedItems;
        return Scaffold(
          backgroundColor: pureWhite,
          appBar: AppBar(
            centerTitle: selectedItems.isNotEmpty ? false : true,
            title: selectedItems.isNotEmpty
                ? Text(
                    "${selectedItems.length}",
                    style: const TextStyle(
                        fontSize: 25,
                        color: cetaceanBlue,
                        fontFamily: 'Nunito'),
                    textAlign: TextAlign.left,
                  )
                : const Text(
                    "Timer",
                    style: TextStyle(
                        color: cetaceanBlue, fontFamily: 'Nunito-Bold'),
                  ),
            leading: selectedItems.isNotEmpty
                ? Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Expanded(
                        child: IconButton(
                          iconSize: Checkbox.width,
                          key: const Key('close-multiselect'),
                          onPressed: () {
                            setState(() {
                              selectedItems.clear();
                              updateSelectedItems(selectedItems);
                            });
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Flexible(
                        child: IconButton(
                          iconSize: Checkbox.width,
                          key: const Key('back'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NavbarBottom(),
                              ),
                            );
                          },
                          padding: const EdgeInsets.only(left: 20).w,
                          icon: SvgPicture.asset(
                            "assets/images/button_back.svg",
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
            actions: [
              selectedItems.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          selectedItems.length == 1
                              ? IconButton(
                                  /*  --------------------------------HANDLER EDIT------------------------------------------- */
                                  onPressed: () {
                                    // Get the ID of the selected item
                                    int id = selectedItems.first;
                                    // Show the edit modal for the selected item
                                    _showModal((int? id) {}, id);
                                  } /* => _showModal((int? id) {}, _allData[index]['id'])*/,
                                  icon: SvgPicture.asset(
                                      "assets/images/edit_ui.svg",
                                      width: 23,
                                      height: 23),
                                )
                              : Container(),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    surfaceTintColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.68,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.42,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            child: SvgPicture.asset(
                                              'assets/images/confirm_popup.svg',
                                              fit: BoxFit.contain,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                            ),
                                          ),
                                          const Text(
                                            "Timer akan dihapus,",
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: halfGrey,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "Tidak",
                                                    style: TextStyle(
                                                        color: offGrey),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 30),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: ripeMango,
                                                ),
                                                /*  --------------------------------HANDLER DELETE------------------------------------------- */
                                                child: TextButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      if (selectedItems.length >
                                                          2) {
                                                        for (int id
                                                            in selectedItems) {
                                                          SQLHelper.deleteData(
                                                              id);
                                                        }
                                                        _refreshData();
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const NavbarBottom(),
                                                          ),
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: const Text(
                                                    "Ya",
                                                    style: TextStyle(
                                                        color: offGrey),
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
                            },
                            icon: SvgPicture.asset(
                                "assets/images/delete_ui.svg",
                                width: 23,
                                height: 23),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
            backgroundColor: pureWhite,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: TabBar(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                dividerColor: Colors.transparent,
                onTap: (index) {
                  setState(() {
                    selectedIndex;
                  });
                },
                tabs: [
                  Tab(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                      ),
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.35,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: selectedIndex == 0 ? ripeMango : halfGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Semua',
                            style: TextStyle(
                                color: selectedIndex == 0
                                    ? pureWhite
                                    : cetaceanBlue),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 15,
                      ),
                      child: Container(
                        alignment: Alignment.topCenter,
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.35,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: selectedIndex == 0 ? halfGrey : ripeMango,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Timer Mu',
                            style: TextStyle(
                                color: selectedIndex == 1
                                    ? pureWhite
                                    : cetaceanBlue),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.transparent,
                  ),
                ),
                labelColor: pureWhite,
                splashFactory: NoSplash.splashFactory,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return RecommendationTimerPage(
                        isSettingPressed: isSettingPressed);
                  } else {
                    return _allData.isEmpty
                        ? const Center(child: Text(""))
                        : ListTimerPageHold(
                            isSettingPressed: isSettingPressed,
                          );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _allData.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/cat_setting.svg",
                            width: screenSize.width * 0.3,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02),
                          const Text(
                            "Ayo tambahkan timer sesuai keinginanmu!",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              color: darkGrey,
                            ),
                          ),
                        ],
                      )
                    : ListTimerPageHold(
                        isSettingPressed: isSettingPressed,
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
