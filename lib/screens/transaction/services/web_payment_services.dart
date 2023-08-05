import 'dart:core';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/my_cart_model.dart';
import 'package:bookkart_flutter/screens/bookView/view/web_view_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/screens/transaction/model/line_items_model.dart';
import 'package:bookkart_flutter/screens/transaction/transaction_repository.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class WebPayment {
  final String bookID;
  final BuildContext context;

  WebPayment({required this.context, required this.bookID});

  List<LineItemsRequest> lineItems = [];

  Future placeOrder(BuildContext context) async {
    if (!appStore.isLoggedIn) SignInScreen().launch(getContext);

    for (CardModel myCart in cartStore.cartList) {
      lineItems.add(LineItemsRequest(productId: myCart.id, quantity: myCart.projectedQty.validate().toString()));
    }

    List<Map> lineItemJson = [];
    lineItems.forEach((element) {
      lineItemJson.add(element.toJson());
    });

    void fail() {
      afterTransaction(
        context,
        bookId: bookID,
        isClearCart: false,
        isShowErrorMessage: true,
        isSuccess: false,
      );
    }

    Map<String, dynamic> request = {
      'currency': getStringAsync(CURRENCY_NAME),
      'customer_id': appStore.userId.toString(),
      'payment_method': "",
      'set_paid': false,
      'status': "pending",
      'transaction_id': "",
      'line_items': lineItemJson,
    };

    log(request);

    appStore.setLoading(true);

    await bookOrderRestApi(request).then((response) async {
      appStore.setLoading(false);

      Map<String, String> request = {"order_id": response.id.toString()};
      log(request);

      await checkoutURLRestApi(request).then((res) async {
        await WebViewScreen(url: res.checkoutUrl.validate(), title: "Payment", orderId: response.id.toString()).launch(context).then((results) async {
          if (results != null && results.containsKey('orderCompleted')) {
            afterTransaction(context, bookId: bookID, isClearCart: true, isShowErrorMessage: false, isSuccess: true);
            LiveStream().emit(REFRESH_LIST);
          } else {
            await deleteOrderRestApi(response.id.toString()).then((value) {
              afterTransaction(context, bookId: bookID, isClearCart: false, isShowErrorMessage: true, msg: 'Order cancelled', isSuccess: false);
            }).catchError((e) {
              fail();
            });
          }
        });
      }).catchError((e) async {
        fail();
      });
    }).catchError((error) {
      fail();
    });
  }

  Future singleOrder({required String bookId}) async {
    String currency = getStringAsync(CURRENCY_NAME);

    Map<String, dynamic> request = {
      'currency': currency,
      'customer_id': appStore.userId,
      'payment_method': "",
      'set_paid': false,
      'status': "pending",
      'transaction_id': "",
      'line_items': [
        {
          "product_id": bookId,
          "quantity": 1,
        }
      ],
    };

    log(request);

    await bookOrderRestApi(request).then((response) async {
      Map<String, dynamic> requestCheckout = {'order_id': response.id};

      await checkoutURLRestApi(requestCheckout).then((res) async {
        Map? results = await WebViewScreen(
          url: res.checkoutUrl.toString(),
          title: "Payment",
          orderId: response.id.toString(),
        ).launch(getContext);

        if (results != null && results.containsKey('orderCompleted')) {
          afterTransaction(context, bookId: bookID, isClearCart: true, isShowErrorMessage: false, isSuccess: true);
        } else {
          afterTransaction(context, bookId: bookID, isClearCart: false, isShowErrorMessage: false, msg: 'Order cancelled', isSuccess: true);
        }
      });
    }).catchError((e) {
      afterTransaction(context, bookId: bookID, isClearCart: false, isShowErrorMessage: true, isSuccess: true);
    });
  }
}
