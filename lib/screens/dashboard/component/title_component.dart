import 'package:bookkart_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TitleComponent extends StatelessWidget {
  final String title;

  final bool? showHello;

  TitleComponent(this.title, {Key? key, this.showHello}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHello ?? true)
          Container(
            padding: EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.green, width: 3.0))),
            child: Text(locale.lblHello, style: primaryTextStyle(size: 26)),
          ),
        8.width,
        Text(title.capitalizeFirstLetter(), style: primaryTextStyle(size: 26)),
      ],
    );
  }
}
