import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/services/auth_services.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class GoogleSignIn extends StatelessWidget {
  final bool isRemember;
  final String password;
  final String userName;

  GoogleSignIn({required this.isRemember, required this.password, required this.userName});

  void googleSignIn(BuildContext context) async {
    if (!appStore.isNetworkAvailable) {
      toast("No Internet Found");
      return;
    }

    appStore.setLoading(true);
    await authService.signInWithGoogle().then((value) async {
      appStore.setLoading(false);
      if (value == null) return;

      await setUserInfo(value, isRemember: isRemember, password: password, username: userName);
      await DashboardScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      appStore.setLoading(false);
      if (!appStore.isNetworkAvailable) {
        toast("No Internet Found");
      } else {
        toast("Something Went Wrong");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: '',
      color: context.cardColor,
      padding: EdgeInsets.all(8),
      textStyle: boldTextStyle(),
      shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
      width: context.width() - context.navigationBarHeight,
      onTap: () {
        googleSignIn(context);
      },
      child: Row(
        children: [
          Container(
            child: GoogleLogoWidget(size: 18),
            padding: EdgeInsets.all(12),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor.withOpacity(0.1), boxShape: BoxShape.circle),
          ),
          Text(locale.signInWithGoogle, style: boldTextStyle(size: 14), textAlign: TextAlign.center).expand(),
        ],
      ),
    );
  }
}
