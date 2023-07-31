import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/base_response_model.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/transaction/model/checkout_model.dart';
import 'package:bookkart_flutter/screens/transaction/model/line_items_model.dart';
import 'package:bookkart_flutter/screens/transaction/model/order_model.dart';
import 'package:bookkart_flutter/screens/transaction/model/verify_transaction_response.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Future<BaseResponseModel> deleteOrderRestApi(String request) async {
  log('DELETE-ORDER-REST-API');
  return BaseResponseModel.fromJson(await responseHandler(await APICall().getMethod("wc/v3/orders/$request")));
}

Future<BaseResponseModel> clearCart() async {
  log('CLEAR-CART');
  return BaseResponseModel.fromJson(await responseHandler(await APICall().getMethod('iqonic-api/api/v1/cart/clear-cart', requireToken: true)));
}

Future<CheckoutResponse> checkoutURLRestApi(Map<String, dynamic> request) async {
  log('CHECK-OUT-URL-REST-API');
  return CheckoutResponse.fromJson(await responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/get-checkout-url", request, requireToken: true)));
}

Future<OrderResponse> bookOrderRestApi(Map<String, dynamic> request) async {
  log('BOOK-ORDER-REST-API');
  return OrderResponse.fromJson(await responseHandler(await APICall().postMethod("wc/v3/orders", request, requireToken: true)));
}

Future<BaseResponseModel> deleteFromCart(Map<String, dynamic> request) async {
  log('DELETE-FROM-CART');
  return BaseResponseModel.fromJson(await responseHandler(await APICall().postMethod('iqonic-api/api/v1/cart/delete-cart/', request, requireToken: true)));
}

Future<VerifyTransactionResponse> verifyPayment({required String transactionId, required String flutterWaveSecretKey}) async {
  log('VERIFY-PAYMENT-API');
  return VerifyTransactionResponse.fromJson(await handleResponse(await buildHttpResponse("https://api.flutterwave.com/v3/transactions/$transactionId/verify", isFlutterWave: true, flutterWaveSecretKey: flutterWaveSecretKey)));
}
//endregion

Future<bool> createNativeOrder(
  BuildContext context, {
  required int bookingId,
  required String paymentMethodName,
  required bool isSingleItem,
  String status = "completed",
  String transactionId = "",
}) async {
  log('CREATE-NATIVE-ORDER');
  if (!appStore.isLoggedIn) {
    SignInScreen().launch(context);
    return false;
  }

  Map<String, dynamic> request = {
    'currency': getStringAsync(CURRENCY_NAME),
    'customer_id': appStore.userId,
    'payment_method': paymentMethodName,
    'set_paid': true,
    'status': status,
    'transaction_id': transactionId,
  };

  if (isSingleItem.validate(value: true)) {
    request.putIfAbsent(
        'line_items',
        () => [
              {"product_id": bookingId, "quantity": 1}
            ]);
  } else {
    List<LineItemsRequest> lineItems = [];

    cartStore.cartList.forEach((element) {
      lineItems.add(LineItemsRequest(
        productId: element.proId,
        quantity: element.quantity,
      ));
    });

    request.putIfAbsent('line_items', () => lineItems);
  }

  log(request);

  return await bookOrderRestApi(request).then((res) {
    if (isSingleItem) {
      afterTransaction(context, bookId: bookingId.toString(), isClearCart: false, isShowErrorMessage: false, isSuccess: true);
    } else {
      afterTransaction(context, bookId: bookingId.toString(), isClearCart: true, isShowErrorMessage: false, isSuccess: true);
    }

    LiveStream().emit(REFRESH_LIST);
    return true;
  }).catchError((onError) {
    afterTransaction(context, bookId: bookingId.toString(), isClearCart: false, isShowErrorMessage: true, isSuccess: false);
    return false;
  });
}
