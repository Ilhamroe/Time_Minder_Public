import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> homePageTargets({
  required GlobalKey cardHomeKey,
  required GlobalKey gridRekomendasiKey,
  required GlobalKey timerMuKey,
}) {
  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
    keyTarget: cardHomeKey,
    radius: 10.r,
    shape: ShapeLightFocus.RRect,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return CoachMarkDesc(
            step: "1/3",
            title: "Target harian.",
            desc: "Catatan ini akan melacak aktivitas Anda hari ini.",
            skip: "Lewati",
            next: "Selanjutnya",
            onSkip: () {
              controller.skip();
            },
            onNext: () {
              controller.next();
            },
          );
        },
      ),
    ],
  ));

  targets.add(TargetFocus(
    keyTarget: gridRekomendasiKey,
    alignSkip: Alignment.topRight,
    radius: 10.r,
    shape: ShapeLightFocus.RRect,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return CoachMarkDesc(
            step: "2/3",
            title: "Rekomendasi",
            desc:
                "Telusuri daftar timer yang sudah disiapkan, termasuk timer Pomodoro, Long Timer, dan juga Short Timer",
            skip: "Lewati",
            next: "Selanjutnya",
            onSkip: () {
              controller.skip();
            },
            onNext: () {
              controller.next();
            },
          );
        },
      ),
    ],
  ));

  targets.add(TargetFocus(
    keyTarget: timerMuKey,
    alignSkip: Alignment.topRight,
    radius: 10.r,
    shape: ShapeLightFocus.RRect,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) {
          return CoachMarkDesc(
            step: "3/3",
            title: "Timer Mu",
            desc: "Ini adalah daftar timer kustom yang telah Anda buat.",
            skip: "Lewati",
            next: "Selesai",
            onSkip: () {
              controller.skip();
            },
            onNext: () {
              controller.next();
            },
          );
        },
      ),
    ],
  ));

  // Return targets
  return targets;
}

class CoachMarkDesc extends StatefulWidget {
  const CoachMarkDesc({
    super.key,
    required this.step,
    required this.title,
    required this.desc,
    required this.skip,
    required this.next,
    required this.onSkip,
    required this.onNext,
  });

  final String step;
  final String title;
  final String desc;
  final String skip;
  final String next;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  State<CoachMarkDesc> createState() => _CoachMarkDescState();
}

class _CoachMarkDescState extends State<CoachMarkDesc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15).w,
      decoration: BoxDecoration(
        color: cetaceanBlue,
        borderRadius: BorderRadius.circular(10).w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.step,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15.0.sp),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 1.0).r,
            child: Text(
              widget.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20.0.sp),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 1.0).r,
            child: Text(
              widget.desc,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: widget.onSkip,
                child: Text(
                  widget.skip,
                  style: const TextStyle(
                    color: pureWhite,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5).r,
                )),
                child: Text(
                  widget.next,
                  style: const TextStyle(
                    color: cetaceanBlue,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
