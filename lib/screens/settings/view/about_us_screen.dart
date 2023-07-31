// import 'package:bookkart_flutter/main.dart';
// import 'package:bookkart_flutter/utils/common_base.dart';
// import 'package:bookkart_flutter/utils/constants.dart';
// import 'package:bookkart_flutter/utils/images.dart';
// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
//
// class AboutUsScreen extends StatelessWidget {
//   AboutUsScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarWidget(locale.lblAbout),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.transparent),
//               borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
//               boxShadow: [
//                 BoxShadow(color: Colors.transparent),
//               ],
//             ),
//             child: Image.asset(ic_logo, width: 100, height: 100),
//           ).center(),
//           16.height,
//           SnapHelperWidget<PackageInfoData>(
//             future: getPackageInfo(),
//             onSuccess: (snap) => Column(
//               children: [
//                 Text('${snap.appName.validate()}', style: boldTextStyle(size: 20)),
//                 Text('V ${snap.versionName.validate()}', style: secondaryTextStyle()),
//               ],
//             ),
//           ),
//           16.height,
//           AppButton(
//             color: context.primaryColor,
//             textStyle: boldTextStyle(color: Colors.white),
//             padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
//             text: locale.lblPurchase,
//             onTap: () {
//               commonLaunchUrl(PURCHASE_URL);
//             },
//           )
//         ],
//       ).center(),
//       bottomNavigationBar: Container(
//         width: context.width(),
//         height: 180,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (getStringAsync(WHATSAPP).isNotEmpty) Text(locale.lblFollowUs, style: boldTextStyle()),
//             16.height,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 16.width,
//                 if (getStringAsync(WHATSAPP).isNotEmpty) InkWell(onTap: () => commonLaunchUrl('${getStringAsync(WHATSAPP)}'), child: Image.asset(ic_whatsapp, height: 35, width: 35).paddingAll(10)),
//                 if (getStringAsync(INSTAGRAM).isNotEmpty) InkWell(onTap: () => commonLaunchUrl(getStringAsync(INSTAGRAM)), child: Image.asset(ic_instagram, height: 35, width: 35).paddingAll(10)),
//                 if (getStringAsync(TWITTER).isNotEmpty) InkWell(onTap: () => commonLaunchUrl(getStringAsync(TWITTER)), child: Image.asset(ic_twitter, height: 35, width: 35).paddingAll(10)),
//                 if (getStringAsync(FACEBOOK).isNotEmpty) InkWell(onTap: () => commonLaunchUrl(getStringAsync(FACEBOOK)), child: Image.asset(ic_facebook, height: 35, width: 35).paddingAll(10)),
//                 if (getStringAsync(CONTACT).isNotEmpty) InkWell(onTap: () => commonLaunchUrl('${getStringAsync(CONTACT)}'), child: Image.asset(ic_call_ring, height: 35, width: 35).paddingAll(10)),
//                 16.width
//               ],
//             ),
//             Text((getStringAsync(COPYRIGHT_TEXT).isNotEmpty) ? getStringAsync(COPYRIGHT_TEXT) : '', style: secondaryTextStyle()),
//             4.height,
//           ],
//         ),
//       ),
//     );
//   }
// }
