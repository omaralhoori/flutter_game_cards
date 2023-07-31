import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookmark/model/bookmark_response_model.dart';
import 'package:bookkart_flutter/utils/extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookmarkListComponent extends StatelessWidget {
  final BookmarkResponse bookData;

  BookmarkListComponent(this.bookData);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(defaultRadius),
          child: CachedImageWidget(url: bookData.full.validate(), fit: BoxFit.cover, height: 100, width: 80),
        ),
        16.width,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            16.height,
            Text(bookData.name.validate(), style: boldTextStyle()),
            if (bookData.freeBook) Text(locale.lblFree, style: boldTextStyle(color: Colors.green)),
            if (bookData.hasPrice)
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bookData.salePrice.validate().getFormattedPrice(), style: boldTextStyle()),
                  16.width.visible(bookData.salePrice.toString().validate().isNotEmpty),
                  Text(
                    bookData.regularPrice.validate().getFormattedPrice(),
                    style: boldTextStyle(color: bookData.salePrice.validate().isNotEmpty ? Colors.grey : context.primaryColor, decoration: bookData.regularPrice.validate().toDouble() == 0.0 ? TextDecoration.lineThrough : TextDecoration.none),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
