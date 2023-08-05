import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/screens/transaction/component/payment_sheet_component.dart';
import 'package:bookkart_flutter/screens/transaction/view/my_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewFileButton extends StatefulWidget {
  final CardModel bookInfo;
  final String bookId;

  ViewFileButton({Key? key, required this.bookInfo, required this.bookId}) : super(key: key);

  @override
  State<ViewFileButton> createState() => _ViewFileButtonState();
}

class _ViewFileButtonState extends State<ViewFileButton> {
  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  Future<void> addToCart() async {
    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context);
      return;
    }

    // if ((cartStore.isCartItemPreExist(bookId: widget.bookInfo.id.validate().toInt()))) {
    //   await MyCartScreen(bookInfo: widget.bookInfo).launch(context);
    //   return;
    // }

    appStore.setLoading(true);
    await cartStore.addToCart(context, bookId: widget.bookId, card: widget.bookInfo).then((value) {
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
      toast("Try Again");
    });
  }

  Future<void> buyNow({required CardModel bookInfo}) async {
    if (appStore.isLoggedIn) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return PaymentSheetComponent(bookInfo: bookInfo, isSingleItem: true);
        },
      );
    } else {
      SignInScreen().launch(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.bookInfo.projectedQty == 0) return SizedBox(width: context.width());

    return Observer(builder: (_) {
      return Container(
        width: context.width(),
        margin: EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(defaultRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: addToCart,
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: kToolbarHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius)),
                child: Text(
                  locale.lblAddToCart, //cartStore.cartList.any((element) => element.proId.validate() == int.tryParse(widget.bookId))) ? locale.lblGoToCart : 
                  style: primaryTextStyle(color: white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // SizedBox(height: 28, child: VerticalDivider(color: Colors.white, thickness: 1.5)),
            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () {
            //     buyNow(bookInfo: widget.bookInfo);
            //   },
            //   child: Container(
            //     height: kToolbarHeight,
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius)),
            //     child: Text(locale.lblBuyNow, style: primaryTextStyle(color: white)),
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
