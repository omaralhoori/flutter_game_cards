import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_model.dart';
import 'package:bookkart_flutter/screens/dashboard/component/all_sub_category_component.dart';
import 'package:bookkart_flutter/utils/extensions/int_extensions.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final String invoiceId;
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  Future<List<InvoiceModel>>? future;
   @override
  void initState() {
    super.initState();
    init();
  }
   Future<void> init() async {
    future = getInvoiceDetails(widget.invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: CustomAppBar(title1: '', title2: locale.lblMyOrders, isHome: false), actions: [
        IconButton(
          onPressed: (){
            cartStore.printInvoice(widget.invoiceId);
          }, 
          iconSize: 28,
          icon: Icon(Icons.print))
      ],),
      body: NoInternetFound(
        child: SnapHelperWidget<List<InvoiceModel>>(
          future: future,
          loadingWidget: AppLoader(),
          errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
          defaultErrorMessage: locale.lblNoDataFound,
          onSuccess: (snap) {
            if (snap.isEmpty) {
              return BackgroundComponent(
                text: locale.lblNoDataFound,
                showLoadingWhileNotLoading: true,
              ).paddingOnly(top: 16, left: 16);
            }

            return AnimatedScrollView(
              padding: EdgeInsets.only(bottom: 16),
              children: [
                AnimatedListView(
                  shrinkWrap: true,
                  itemCount: snap.length,
                  listAnimationType: ListAnimationType.Scale,
                  padding: EdgeInsets.only(left: 16, right: 16),
                 physics: ClampingScrollPhysics(),
                  itemBuilder: (_, index) {
                    InvoiceModel invoiceModel = snap[index];
                    return InvoiceItem(invoice: invoiceModel);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class InvoiceItem extends StatefulWidget {
  final InvoiceModel invoice;
  InvoiceItem({super.key, required this.invoice});

  @override
  State<InvoiceItem> createState() => _InvoiceItemState();
}

class _InvoiceItemState extends State<InvoiceItem> {
   String dateFormat = DateFormat("yMMMd").toString();
  bool copied =false;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    // transactionListData!.lineItems.validate().forEach((lineItem) => lineItems = lineItem);
    dateFormat = DateFormat("yMMMd").format(DateTime.parse(widget.invoice.postingDate.toString()));
  }

  Widget buildImageWidget() {
    //if (lineItems!.productImages.validate().isNotEmpty) {
      return CachedImageWidget(
        height: 100,
        width: 80,
        fit: BoxFit.cover,
        radius: 8,
        url: formatImageUrl(widget.invoice.image.validate()),
      );
    // } else {
    //   return Offstage();
    // }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        await Clipboard.setData(ClipboardData(text: widget.invoice.serialNo));
        setState(() {
          this.copied = true;
        });
      },
      child: Column(
        children: [
          8.height,
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(ic_order_id, height: 24, width: 24, fit: BoxFit.fill, color: context.iconColor),
                    4.width,
                    Text("${widget.invoice.serialNo.validate()}", style: secondaryTextStyle()).expand(),
                    16.width,
                    copied ? Text(
                      'Copied',
                      style: boldTextStyle(
                        color: Colors.green     
                      )):Icon(Icons.copy)
                    
                  ],
                ),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildImageWidget(),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.invoice.itemCode.validate()}', style: boldTextStyle(), maxLines: 2),
                        Text(dateFormat.validate(), style: secondaryTextStyle()),
                        Marquee(child: Text(widget.invoice.invoiceId, style: secondaryTextStyle(size: 12))),
                        Text(widget.invoice.itemRate.toString().validate().getFormattedPrice(), style: boldTextStyle()),
                      ],
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}