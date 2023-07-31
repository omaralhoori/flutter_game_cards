import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/dashboard_repository.dart';
import 'package:bookkart_flutter/screens/dashboard/model/book_purchase_model.dart';
import 'package:bookkart_flutter/screens/transaction/component/transaction_component.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  Future<List<LineItems>>? future;

  List<LineItems> services = [];
  List<BookPurchaseResponse> transactionListData = [];

  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() {
    if (!appStore.isNetworkAvailable) {
      appStore.setLoading(false);
      return;
    }

    future = getPurchasedRestApi(
      services: services,
      lastPageCallBack: (p0) => isLastPage = p0,
      perPage: 15,
      page: page,
      list: (list) => transactionListData = list,
    );
  }

  Widget _buildTransactionHistoryList() {
    if (transactionListData.isNotEmpty) {
      return AnimatedListView(
        itemCount: transactionListData.length,
        padding: EdgeInsets.only(left: 16, right: 16),
        physics: ClampingScrollPhysics(),
        onNextPage: () {
          if (!isLastPage) {
            page++;
            init();
            setState(() {});
          }
        },
        itemBuilder: (context, index) {
          return TransactionComponent(transactionListData: transactionListData[index]);
        },
      );
    }

    return BackgroundComponent(text: locale.lblNoTransactionDataFound, showLoadingWhileNotLoading: true).center();
  }

  @override
  void dispose() {
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblTransactionHistory),
      body: NoInternetFound(
        child: SnapHelperWidget<List<LineItems>>(
          future: future,
          loadingWidget: AppLoader(),
          errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
          defaultErrorMessage: locale.lblNoDataFound,
          onSuccess: (snap) {
            return _buildTransactionHistoryList();
          },
        ),
      ),
    );
  }
}
