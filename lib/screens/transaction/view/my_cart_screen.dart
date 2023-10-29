import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/invoice_details_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/screens/transaction/component/cart_component.dart';
import 'package:bookkart_flutter/screens/transaction/view/credit_card_screen.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class MyCartScreen extends StatefulWidget {
  final CardModel? bookInfo;
  final bool showBack;

  MyCartScreen({this.bookInfo,this.showBack=true, Key? key}) : super(key: key);

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  Future<void> checkout(BuildContext context) async {
   
     if(appStore.isLoggedIn){
    showConfirmDialogCustom(
        title: locale.checkoutConfirm,
        context,
        dialogType: DialogType.CONFIRMATION,
        positiveText: locale.confirm,
        negativeText: locale.lblCancel,
        onAccept: (e) async {
           
        
          final res = await cartStore.checkoutCart(context);
          if (res['success_key'] == 0){
            toastLong(res['error']);
          }else if (res['success_key'] == 1){
            cartStore.cleanCart();
            InvoiceDetailScreen(invoiceId: res['invoice']).launch(context);
          }
          
            },
          );
          }else{
            CreditCardScreen(total: cartStore.totalAmount,).launch(context);
            //
          }
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() async {
    cartStore.init();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.lblMyCart, 
        titleWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(locale.lblMyCart, style:primaryTextStyle(size: 20, weight: FontWeight.bold) ,),
            Text(locale.lblBalance +": " + cartStore.customerBalance.toString(), style: primaryTextStyle(size: 20),)
          ],),
        ),
        showBack: widget.showBack, 
        center: !widget.showBack),
      body: NoInternetFound(
        child: Observer(
          builder: (context) {
            return Stack(
              children: [
                AnimatedListView(
                  itemCount: cartStore.cartList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                  physics: ClampingScrollPhysics(),
                  emptyWidget: BackgroundComponent(text: locale.lblEmptyCart, showLoadingWhileNotLoading: cartStore.cartList.isEmpty).center(),
                  itemBuilder: (context, index) {
                    return OpenBookDescriptionOnTap(
                      bookId: cartStore.cartList[index].id,
                      currentIndex: index,
                      child: CartComponent(index: index).paddingBottom(16),
                    );
                  },
                ),
                AppLoader(loadingVisible: true, isObserver: true),
                if (cartStore.cartList.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 120,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(locale.lblTotal, style: primaryTextStyle()).expand(),
                              Observer(builder: (context) {
                                return Text(cartStore.totalAmount.toString().getFormattedPrice(), style: boldTextStyle());
                              }),
                            ],
                          ),
                          8.height,
                          AppButton(
                            text: locale.lblCheckOut,
                            textColor: white,
                            color: context.primaryColor,
                            width: context.width(),
                            onTap: () {
                              checkout(context);
                            },
                          )
                        ],
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
