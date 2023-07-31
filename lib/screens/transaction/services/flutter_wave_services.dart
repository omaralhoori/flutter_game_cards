import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/screens/transaction/transaction_repository.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:uuid/uuid.dart';

class FlutterWaveServices {
  final BuildContext context;
  final Customer customer = Customer(
    name: appStore.userName,
    phoneNumber: appStore.userContactNumber,
    email: appStore.userEmail,
  );

  FlutterWaveServices({required this.context});

  void payWithFlutterWave({
    required BookDataModel bookData,
    required num totalAmount,
    required String flutterWavePublicKey,
    required String flutterWaveSecretKey,
    required bool isTestMode,
    required bool isSingleItem,
  }) async {
    String transactionId = Uuid().v1();

    Flutterwave flutterWave = Flutterwave(
      context: getContext,
      publicKey: FLUTTER_WAVE_PUBLIC_KEY,
      currency: getStringAsync(CURRENCY_NAME),
      redirectUrl: BASE_URL,
      txRef: transactionId,
      amount: totalAmount.validate().toStringAsFixed(0),
      customer: customer,
      paymentOptions: "card, payattitude, barter",
      customization: Customization(title: "Pay With Flutterwave", logo: ic_logo),
      isTestMode: isTestMode,
    );

    /// Note : after futter
    await flutterWave.charge().then((value) {
      if (value.status == "successful") {
        appStore.setLoading(true);

        verifyPayment(
          transactionId: value.transactionId.validate(),
          flutterWaveSecretKey: flutterWaveSecretKey,
        ).then((v) {
          if (v.status == "success") {
            toast(v.status);
            createNativeOrder(
              context,
              paymentMethodName: PAYMENT_METHOD_FLUTTER_WAVE,
              isSingleItem: isSingleItem,
              bookingId: bookData.id.validate(),
              transactionId: value.transactionId.validate(),
            );
          } else {
            toast(v.status);
            afterTransaction(
              context,
              bookId: bookData.id.validate().toString(),
              isClearCart: false,
              isShowErrorMessage: true,
              msg: v.status.toString(),
              isSuccess: true,
            );
          }
        }).catchError((e) {
          afterTransaction(
            context,
            bookId: bookData.id.validate().toString(),
            isClearCart: false,
            isShowErrorMessage: true,
            isSuccess: false,
          );
        });
      } else {
        afterTransaction(
          context,
          bookId: bookData.id.validate().toString(),
          isClearCart: false,
          isShowErrorMessage: true,
          msg: 'Order cancelled',
          isSuccess: false,
        );
      }
    }).catchError((e) {
      afterTransaction(
        context,
        bookId: bookData.id.validate().toString(),
        isClearCart: false,
        isShowErrorMessage: true,
        isSuccess: false,
      );
    });
  }
}
