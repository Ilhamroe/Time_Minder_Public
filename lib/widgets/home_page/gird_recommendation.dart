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
    final screenSize = MediaQuery.of(context).size;
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenSize.width < 200.w ? 2 : 3,
        crossAxisSpacing: screenSize.width * 0.03.w,
        mainAxisExtent: 187.w,
      ),
      itemCount: Timerlist.length,
      itemBuilder: (context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenSize.width * 0.03.w),
            color: offOrange,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: screenSize.width * 0.03.w),
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.width * 0.03.w,
                  horizontal: screenSize.width * 0.04.w,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(screenSize.width * 0.04.w),
                  color: heliotrope,
                ),
                child: SvgPicture.asset(
                  Timerlist[index].image,
                  height: screenSize.width * 0.1.h,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.02.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Timerlist[index].title,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: screenSize.width * 0.037.sp,
                        fontWeight: FontWeight.bold,
                        color: cetaceanBlue,
                      ),
                    ),
                    SizedBox(height: screenSize.width * 0.01.h),
                    Text(
                      Timerlist[index].description,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: screenSize.width * 0.025.sp,
                        fontWeight: FontWeight.w800,
                        color: cetaceanBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenSize.width * 0.01.h),
                    Text(
                      Timerlist[index].time,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: screenSize.width * 0.025.sp,
                        fontWeight: FontWeight.w800,
                        color: darkGrey,
                      ),
                    ),
                    SizedBox(height: screenSize.width * 0.01.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimerView(timerIndex: index),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5).w,
                        padding: EdgeInsets.symmetric(horizontal: 0.01).w,
                        decoration: BoxDecoration(
                          color: ripeMango,
                          borderRadius:
                              BorderRadius.circular(screenSize.width * 0.02.w),
                        ),
                        child: Center(
                          child: Text(
                            "Mulai",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: screenSize.width * 0.04.sp,
                              color: pureWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}