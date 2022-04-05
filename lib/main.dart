import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/data/themedata.dart';

import 'package:heatlth_monitor/app/services/auth.dart';
import 'package:page_transition/page_transition.dart';

import 'app/data/asset_paths.dart';
import 'app/modules/pages/views/auth_view.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder: () => GetMaterialApp(
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        title: "Health Monitor",
        home: AnimatedSplashScreen(
          nextScreen: AuthView(auth: Auth()),
          splashIconSize: 150.0,
          animationDuration: const Duration(seconds: 1),
          pageTransitionType: PageTransitionType.fade,
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: kMainColor,
          duration: 2000,
          splash: kAppLogo,
        ),
        debugShowCheckedModeBanner: false,
        theme: primaryTheme,
      ),
    );
  }
}
