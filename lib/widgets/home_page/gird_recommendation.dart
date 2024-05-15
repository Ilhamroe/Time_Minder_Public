import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/models/list_timer.dart';
import 'package:time_minder/pages/view_timer_recommedation_page.dart';
import 'package:time_minder/utils/colors.dart';

class GridRekomendasi extends StatelessWidget {
  const GridRekomendasi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: timerList.length,
        crossAxisSpacing: 12.8.w,
        mainAxisExtent: 187.w,
      ),
      itemCount: timerList.length,
      itemBuilder: (context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10).w,
            color: offOrange,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // margin: EdgeInsets.only(top: screenSize.width * 0.03.w),
                padding: EdgeInsets.symmetric(
                  vertical: 14.w,
                  horizontal: 14.w,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(16).w,
                  color: heliotrope,
                ),
                child: SvgPicture.asset(
                  timerList[index].image,
                  height: 37.h,
                  width: 37.h,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 3.7,
                    bottom: 4.6).w,
                child: Text(
                  timerList[index].title,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: cetaceanBlue,
                  ),
                ),
              ),
              // SizedBox(height: screenSize.width * 0.01.h),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 5,
                  right: 3,
                ).w,
                child: Text(
                  timerList[index].description,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: cetaceanBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // SizedBox(height: screenSize.width * 0.01.h),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 5,
                  right: 3,
                ).w,
                child: Text(
                  timerList[index].time,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: darkGrey,
                  ),
                ),
              ),
              // SizedBox(height: screenSize.width * 0.01.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0).w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimerView(timerIndex: index),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0).w,
                    padding: const EdgeInsets.symmetric(horizontal: 0.01).w,
                    decoration: BoxDecoration(
                      color: ripeMango,
                      borderRadius:
                          BorderRadius.circular(10.w),
                    ),
                    child: Center(
                      child: Text(
                        "Mulai",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14.sp,
                          color: pureWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}