import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_minder/services/onboarding_routes.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_minder/widgets/common/bottom_navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.forward();
    Future.delayed(const Duration(seconds: 2), () {
      checkFirstSeen();
      Navigator.popAndPushNamed(context, AppRoutes.onboard);
    });
  }

  Future<void> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NavbarBottom(),
        ),
      );
    } else {
      await prefs.setBool('seen', true);
      Navigator.popAndPushNamed(context, AppRoutes.onboard);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: offOrange,
      body: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: child,
            );
          },
          child: SizedBox(
            height: size.height.h,
            width: size.width.w,
            child: Image.asset(
              'assets/images/splash1.png',
              height: 200.h,
            ),
          ),
        ),
      ),
    );
  }
}
