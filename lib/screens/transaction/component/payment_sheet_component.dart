import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/screens/transaction/services/flutter_wave_services.dart';
import 'package:bookkart_flutter/screens/transaction/services/web_payment_services.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class PaymentSheetComponent extends StatefulWidget {
  final BookDataModel? bookInfo;
  final bool isSingleItem;

  PaymentSheetComponent({this.bookInfo, required this.isSingleItem});

  @override
  PaymentSheetComponentState createState() => PaymentSheetComponentState();
}

class PaymentSheetComponentState extends State<PaymentSheetComponent> {
  List paymentList = [RAZORPAY, WEB_PAY, WAVE_PAYMENT];

  int? _currentTimeValue = 0;
  int? paymentIndex;

  String selectedCurrency = "";

  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
          backgroundColor: context.cardColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(defaultRadius), topLeft: Radius.circular(defaultRadius)),
        ),
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              children: [
                if (appStore.paymentMethod == NATIVE)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.lblChoosePaymentMethod, style: boldTextStyle(size: 18)),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.close, color: context.iconColor, size: 24),
                            onPressed: () {
                              finish(context, false);
                            },
                          )
                        ],
                      ),
                      Divider(),
                      AnimatedListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        itemCount: paymentList.length,
                        itemBuilder: (context, index) {
                          return Theme(
                            data: Theme.of(context).copyWith(unselectedWidgetColor: Theme.of(context).iconTheme.color),
                            child: RadioListTile(
                              value: index,
                              dense: true,
                              title: Text(paymentList[index], style: primaryTextStyle()),
                              activeColor: context.primaryColor,
                              contentPadding: EdgeInsets.all(0),
                              groupValue: _currentTimeValue,
                              onChanged: (dynamic ind) {
                                _currentTimeValue = ind;
                                paymentIndex = index;
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if (appStore.isLoggedIn)
                  Observer(
                    builder: (_) {
                      return AppButton(
                        text: locale.lblPay + ' ' + '${widget.isSingleItem ? widget.bookInfo!.price.validate().toString().getFormattedPrice() : cartStore.cartList.sumByDouble((p0) => p0.price.validate().toDouble()).toString().getFormattedPrice()}',
                        textStyle: boldTextStyle(color: white),
                        color: context.primaryColor,
                        onTap: () async {
                          cartStore.init();

                          WebPayment webPayment = WebPayment(context: context, bookID: widget.bookInfo!.id.validate().toString());

                          num totalPrice = widget.isSingleItem ? widget.bookInfo!.price.validate() : cartStore.cartList.sumByDouble((p0) => p0.price.validate().toDouble());

                          if (appStore.paymentMethod == NATIVE) {
                            if (_currentTimeValue == 0) {
                              finish(context);

                              if (widget.bookInfo != null) {
                                toast("Currently Razor Pay Is Not Working We Will Update Soon");
                                // PayByRazor razorPay = PayByRazor(razorKeys: RAZOR_KEY, bookData: widget.bookInfo!, isSingleItems: widget.isSingleItem, context: context, bookID: widget.bookInfo!.id.validate());
                                // razorPay.razorPayCheckout(totalPrice);
                                appStore.setLoading(false);
                              } else {
                                toast('try again');
                              }

                              return;
                            }

                            if (_currentTimeValue == 1) {
                              if (widget.isSingleItem) {
                                finish(context);
                                await webPayment.singleOrder(bookId: widget.bookInfo!.id.validate());
                              } else {
                                await webPayment.placeOrder(context);
                              }

                              return;
                            }

                            if (_currentTimeValue == 2) {
                              finish(context);
                              FlutterWaveServices(context: context).payWithFlutterWave(
                                bookData: widget.bookInfo!,
                                totalAmount: totalPrice,
                                flutterWavePublicKey: FLUTTER_WAVE_PUBLIC_KEY,
                                flutterWaveSecretKey: FLUTTER_WAVE_KEY,
                                isTestMode: false,
                                isSingleItem: widget.isSingleItem.validate(),
                              );
                              return;
                            }
                          } else {
                            finish(context);
                            if (widget.isSingleItem) {
                              webPayment.singleOrder(bookId: widget.bookInfo!.id.validate().toInt());
                            } else {
                              webPayment.placeOrder(context);
                            }
                          }
                          return;
                        },
                      ).center();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
