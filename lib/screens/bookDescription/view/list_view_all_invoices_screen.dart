import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_list_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/invoice_details_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/component/all_sub_category_component.dart';
import 'package:bookkart_flutter/utils/extensions/int_extensions.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class AllInvoicesScreen extends StatefulWidget {
  
  const AllInvoicesScreen({super.key});

  @override
  State<AllInvoicesScreen> createState() => _AllInvoicesScreenState();
}

class _AllInvoicesScreenState extends State<AllInvoicesScreen> {
  bool isLastPage = false;
  int page = 1;
  List<InvoiceListModel> invoices = [];
  Future<List<InvoiceListModel>>? future;
   @override
  void initState() {
    super.initState();
    init();
  }
   Future<void> init() async {
    future = getAllInvoices(page, invoices: invoices, lastPageCallBack: (p0) {
      return isLastPage = p0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: CustomAppBar(title1: '', title2: locale.lblMyOrders, isHome: false)),
      body: NoInternetFound(
        child: SnapHelperWidget<List<InvoiceListModel>>(
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
              onNextPage: () {
                print(isLastPage);
                    if (!isLastPage) {
                      page++;
                      init();
                      setState(() {});
                    }
                  },
              children: [
                AnimatedListView(
                  shrinkWrap: true,
                  itemCount: snap.length,
                  listAnimationType: ListAnimationType.Scale,
                  padding: EdgeInsets.only(left: 16, right: 16),
                 physics: ClampingScrollPhysics(),
                  itemBuilder: (_, index) {
                    InvoiceListModel invoiceModel = snap[index];
                    return InvoiceListItem(invoice: invoiceModel);
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


class InvoiceListItem extends StatefulWidget {
  final InvoiceListModel invoice;
  InvoiceListItem({super.key, required this.invoice});

  @override
  State<InvoiceListItem> createState() => _InvoiceListItemItemState();
}

class _InvoiceListItemItemState extends State<InvoiceListItem> {
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
        InvoiceDetailScreen(invoiceId: widget.invoice.id).launch(context);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildImageWidget(),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.invoice.id.validate()}', style: boldTextStyle(), maxLines: 2),
                        Text(dateFormat.validate(), style: secondaryTextStyle()),
                        Marquee(child: Text(widget.invoice.totalQty.toString(), style: secondaryTextStyle(size: 12))),
                        Text(formatMoney(widget.invoice.grandTotal, widget.invoice.currency), style: boldTextStyle()), //widget.invoice.grandTotal.toString().validate().getFormattedPrice()
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