import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/extensions/int_extensions.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class CartComponent extends StatelessWidget {
  final int index;

  const CartComponent({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartStore.cartList[index].price.validate() * cartStore.cartList[index].qty;
    return Observer(
      builder: (context) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 60,
                  width: 100,
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(120), topRight: Radius.circular(120)),
                    backgroundColor: getBackGroundColor(index: index),
                  ),
                ),
                Container(
                  decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.only(bottom: 16),
                  child: CachedImageWidget(
                    height: 95,
                    width: 75,
                    url: formatImageUrl(cartStore.cartList[index].image.validate()),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            8.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Marquee(child: Text(cartStore.cartList[index].name.validate(), style: boldTextStyle(), maxLines: 2)),
                Text(totalPrice.toString().getFormattedPrice(), style: boldTextStyle()),
                16.height,
                IncreaseDecreaseButtons(card:cartStore.cartList[index])
              ],
            ).expand(),
            16.width,
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Icon(Icons.delete, color: Colors.red),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: radius(8)),
              ),
              onTap: () {
                showConfirmDialogCustom(
                  title: locale.lblAreYouSureWantToDelete,
                  context,
                  dialogType: DialogType.DELETE,
                  onAccept: (e) async {
                    await cartStore.removeAll(context, removeProductId: cartStore.cartList[index].id);
                  },
                );
              },
            )
          ],
        );
      },
    );
  }
}


class IncreaseDecreaseButtons extends StatefulWidget {
  final CardModel card;
  const IncreaseDecreaseButtons({super.key, required this.card});

  @override
  State<IncreaseDecreaseButtons> createState() => _IncreaseDecreaseButtonsState();
}

class _IncreaseDecreaseButtonsState extends State<IncreaseDecreaseButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Icon(Icons.remove, color: context.primaryColor),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(color: context.primaryColor.withOpacity(0.2), borderRadius: radius(8)),
              ),
              onTap: () {
                cartStore.removeFromCart(context, removeProductId: widget.card.id);
              },),
      16.width,  
    Text(widget.card.qty.validate().toString(), style: primaryTextStyle(color: Colors.green)),
      16.width,  
      GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Icon(Icons.add, color: context.primaryColor),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(color: context.primaryColor.withOpacity(0.2), borderRadius: radius(8)),
              ),onTap:(){
                cartStore.increaseCard(widget.card);
              })

    ],);
  }
}