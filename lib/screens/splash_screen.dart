import 'package:bookkart_flutter/components/splash_view.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'auth/view/walk_through_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    setStatusBarColor(Colors.transparent);
    if (getIntAsync(THEME_MODE_INDEX).validate() == THEME_MODE_SYSTEM) appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateTo: appStore.isLoggedIn ? DashboardScreen():SignInScreen(), // (appStore.isFirstTime) ? WalkThroughScreen() : 
      imageSize: 200,
      imageSrc: ic_logo,
      text: locale.appName,
      backgroundColor: context.scaffoldBackgroundColor,
      textType: TextType.ColorizeAnimationText,
      textStyle: boldTextStyle(size: 50),
      colors: [
        context.primaryColor,
        accentColor,
        context.primaryColor,
        accentColor,
        context.primaryColor,
        accentColor,
      ],
    );
  }
}
