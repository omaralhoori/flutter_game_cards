import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_list_model.dart';
import 'package:bookkart_flutter/screens/settings/model/recharge_model.dart';
import 'package:bookkart_flutter/screens/settings/model/transaction_model.dart';
import 'package:bookkart_flutter/screens/settings/settings_repository.dart';
import 'package:bookkart_flutter/utils/app_theme.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/extensions/string_extension.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class RechargeReportScreen extends StatefulWidget {
  
  const RechargeReportScreen({super.key});

  @override
  State<RechargeReportScreen> createState() => _RechargeReportScreenState();
}

class _RechargeReportScreenState extends State<RechargeReportScreen> {
  List<RechargeModel> transactions = [];
  Future<List<RechargeModel>>? future;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
   @override
  void initState() {
    super.initState();
    var request = {"test": "test"};
      future = getRechargeReportRestApi(request);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: CustomAppBar(title1: '', title2: locale.lblRechargeHistory, isHome: false)),
      body: NoInternetFound(
        child: SnapHelperWidget<List<RechargeModel>>(
          future: future,
          loadingWidget: AppLoader(),
          errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
          defaultErrorMessage: locale.lblNoDataFound,
          onSuccess: (snap) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                    snap.isEmpty?
               BackgroundComponent(
            text: locale.lblNoDataFound,
            showLoadingWhileNotLoading: true,
              ).paddingOnly(top: 16, left: 16)
            :RechargeReportDataTable(transactions: snap),
            AppLoader(loadingVisible: true,isObserver: true,)
                ],
              ),
            );
            

        
          },
        ),
      ),
    );
  }
}



class RechargeReportDataTable extends StatelessWidget {
  final List<RechargeModel> transactions;
  const RechargeReportDataTable({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          columns: [
            DataColumn2(
              label: Text(locale.lblDate),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text(locale.lblTime,),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(locale.lblAmount),
              numeric: true,
              size: ColumnSize.S
            ),
            DataColumn2(
              label: Text(locale.lblEntryType),
               size: ColumnSize.M,
            ),
          ],
          rows: List<DataRow>.generate(
              transactions.length,
              (index) => DataRow(cells: [
                    DataCell(Text(transactions[index].posingDate)),
                    DataCell(Text(transactions[index].postingTime)),
                    DataCell(Text(transactions[index].amount.toStringAsFixed(2))),
                    DataCell(Text(transactions[index].transactionType))
                  ]))),
    );
  }
}