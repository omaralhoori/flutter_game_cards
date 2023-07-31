import 'dart:async';

import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookView/book_view_repository.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart' as web_view;

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final String orderId;

  WebViewScreen({required this.url, required this.title, required this.orderId});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  Completer<web_view.WebViewController> webCont = Completer<web_view.WebViewController>();

  bool fetchingFile = true;
  bool? orderDone;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        widget.title.validate(),
        titleTextStyle: boldTextStyle(),
        backWidget: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            finish(context, {'orderCompleted': orderDone});
          },
        ),
      ),
      body: NoInternetFound(
        child: Stack(
          children: [
            web_view.WebView(
              initialUrl: widget.url,
              javascriptMode: web_view.JavascriptMode.unrestricted,
              javascriptChannels: [web_view.JavascriptChannel(name: 'Toaster', onMessageReceived: (web_view.JavascriptMessage message) {})].toSet(),
              navigationDelegate: (web_view.NavigationRequest request) => web_view.NavigationDecision.navigate,
              gestureNavigationEnabled: true,
              onWebViewCreated: (web_view.WebViewController webViewController) {
                webCont.complete(webViewController);
              },
              onPageStarted: (String url) {
                appStore.setLoading(true);
                setState(() {});
              },
              onPageFinished: (String url) async {
                appStore.setLoading(false);
                setState(() {});

                if (url.contains("checkout/order-received")) {
                  Map<String, dynamic> request = {'set_paid': true, 'status': "completed"};

                  updateOrderRestApi(request, widget.orderId).then((res) async {
                    orderDone = true;
                    finish(context, {'orderCompleted': orderDone});
                  }).catchError(onError);
                } else {}
              },
            ),
            AppLoader(isObserver: true),
          ],
        ),
      ),
    );
  }
}
