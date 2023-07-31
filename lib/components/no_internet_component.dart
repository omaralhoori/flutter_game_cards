import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class NoInternetFound extends StatefulWidget {
  final Widget child;
  final void Function()? onRetry;

  NoInternetFound({required this.child, this.onRetry});

  @override
  State<NoInternetFound> createState() => _NoInternetFoundState();
}

class _NoInternetFoundState extends State<NoInternetFound> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (!appStore.isNetworkAvailable) {
          return BackgroundComponent(
            text: locale.lblNoInternet,
            image: img_no_data_found,
            showLoadingWhileNotLoading: true,
            onRetry: () async {
              bool network = await isNetworkAvailable();

              if (widget.onRetry == null) {
                if (network) {
                  await DashboardScreen().launch(context, isNewTask: true);
                } else {
                  toast("${locale.lblNoInternet}");
                }
              } else {
                if (!(network)) {
                  toast("${locale.lblNoInternet}");
                }
                widget.onRetry!.call();
              }
            },
          );
        } else {
          return widget.child;
        }
      },
    );
  }
}
