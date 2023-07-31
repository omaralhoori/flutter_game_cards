import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/screens/transaction/services/flutter_wave_services.dart';
import 'package:bookkart_flutter/screens/transaction/services/web_payment_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

enum PaymentType { STRIPE, FLUTTER_WAVE, NATIVE_PAYMENT, RAZOR_PAY }

class PaymentService {
  final BuildContext context;
  final String bookId;
  BookDataModel? bookInfo;

  PaymentService({required this.context, required this.bookId, required this.bookInfo});

  void makePayment(bool isSingleItem, PaymentType paymentType) {
    cartStore.init();

    if (paymentType == PaymentType.NATIVE_PAYMENT) {
      WebPayment webPayment = WebPayment(context: context, bookID: bookId);
      finish(context);

      if (isSingleItem) {
        webPayment.singleOrder(bookId: bookId.toInt());
      } else {
        webPayment.placeOrder(context);
      }

      return;
    }

    num totalPrice = isSingleItem
        ? bookInfo!.price.validate()
        : cartStore.cartList.sumByDouble(
            (p0) {
              return p0.price.validate().toDouble();
            },
          );

    if (paymentType == PaymentType.FLUTTER_WAVE) {
      finish(context);
      FlutterWaveServices(context: context).payWithFlutterWave(
        bookData: bookInfo!,
        totalAmount: totalPrice,
        flutterWavePublicKey: FLUTTER_WAVE_PUBLIC_KEY,
        flutterWaveSecretKey: FLUTTER_WAVE_KEY,
        isTestMode: false,
        isSingleItem: isSingleItem,
      );
      return;
    }

    if (paymentType == PaymentType.RAZOR_PAY) {
      finish(context);
      toast("Currently Razor Pay Is Not Working We Will Update Soon");
      // TODO :
      // RazorPayServices.init(razorKey: RAZOR_KEY, data: widget.bookInfo, isSingleItem: widget.isSingleItem);
      // await 1.seconds.delay;
      // appStore.setLoading(false);
      // RazorPayServices.razorPayCheckout(totalPrice);
    }
  }
}
