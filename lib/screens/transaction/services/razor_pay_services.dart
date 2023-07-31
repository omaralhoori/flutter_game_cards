// import 'package:bookkart_flutter/configs.dart';
//
// class PayByRazor {
//   final Razorpay razorPay = Razorpay();
//   final String razorKeys;
//
//   final BookDataModel bookData;
//   final BuildContext context;
//   final bool isSingleItems;
//   final int bookID;
//
//   PayByRazor({
//     required this.razorKeys,
//     required this.bookData,
//     required this.isSingleItems,
//     required this.context,
//     required this.bookID,
//   }) {
//     razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
//     razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
//     razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
//   }
//
//   void handlePaymentSuccess(PaymentSuccessResponse response) async {
//     await createNativeOrder(getContext, paymentMethodName: PAYMENT_METHOD_FLUTTER_WAVE, isSingleItem: isSingleItems, bookingId: bookID, transactionId: response.paymentId.validate());
//   }
//
//   Future<void> handlePaymentError(PaymentFailureResponse response) async {
//     afterTransaction(context, isClearCart: false, isShowErrorMessage: true, msg: 'Order cancelled !!!', bookId: bookID.toString(), isSuccess: false);
//   }
//
//   void handleExternalWallet(ExternalWalletResponse response) {
//     afterTransaction(context, isClearCart: false, isShowErrorMessage: false, msg: 'Handled by externalWallet', bookId: bookID.toString(), isSuccess: true);
//   }
//
//   void razorPayCheckout(num mAmount) async {
//     Map<String, dynamic> options = {
//       'key': razorKeys,
//       'amount': (mAmount * 100),
//       'name': APP_NAME,
//       'theme.color': '#5f60b9',
//       'description': "",
//       'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
//       'prefill': {'contact': appStore.userContactNumber, 'email': appStore.userEmail},
//       'external': {
//         'wallets': ['paytm']
//       }
//     };
//
//     try {
//       razorPay.open(options);
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }
// }
// //
