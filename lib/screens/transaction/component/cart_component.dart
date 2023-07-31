import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class CartComponent extends StatelessWidget {
  final int index;

  const CartComponent({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    url: cartStore.cartList[index].thumbnail.validate(),
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
                Text(cartStore.cartList[index].stockStatus.validate(), style: primaryTextStyle(color: Colors.green)),
                Text(cartStore.cartList[index].price.toDouble().toString().getFormattedPrice(), style: boldTextStyle()),
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
                    await cartStore.removeFromCart(context, removeProductId: cartStore.productId[index]);
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
