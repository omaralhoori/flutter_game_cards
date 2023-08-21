import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/invoice_list_model.dart';
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
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TransactionsReportScreen extends StatefulWidget {
  
  const TransactionsReportScreen({super.key});

  @override
  State<TransactionsReportScreen> createState() => _TransactionsReportScreenState();
}

class _TransactionsReportScreenState extends State<TransactionsReportScreen> {
  List<TransactionModel> transactions = [];
  Future<List<TransactionModel>>? future;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
   @override
  void initState() {
    super.initState();
    future = Future(()=>[]);
  }
  _dateChanged() {
   if (fromDateController.text != '' && toDateController.text !=''){
    var request = {"from_date": fromDateController.text, "to_date": toDateController.text};
      future = getTransactionsReportRestApi(request);
   } 
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: CustomAppBar(title1: '', title2: locale.lblTransactionHistory, isHome: false)),
      body: NoInternetFound(
        child: SnapHelperWidget<List<TransactionModel>>(
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
                  AppTextField(
                        textFieldType: TextFieldType.OTHER,
                        controller: fromDateController,
                        errorThisFieldRequired: locale.lblFieldRequired,
                        decoration: inputDecoration(context, locale.lblFromDate),
                        suffix: ic_category.iconImage(size: 10).paddingAll(14),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context, 
                            initialDate: fromDateController.text != '' ? 
                            DateTime.parse(fromDateController.text)
                            : DateTime.now(), 
                            firstDate: DateTime(2000), 
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                                return Theme(
                                 data: Theme.of(context).copyWith(
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: textPrimaryColor, // button text color
                                      ),
                                    ),
                                  ),                                               
                                  child: child!,
                                );
                              },
                            );
                          if(pickedDate != null ){
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                              setState(() {
                                fromDateController.text = formattedDate; //set output date to TextField value. 
                              });
                               _dateChanged();
                          }
                        },
                      ),
                  AppTextField(
                        textFieldType: TextFieldType.OTHER,
                        controller: toDateController,
                        errorThisFieldRequired: locale.lblFieldRequired,
                        decoration: inputDecoration(context, locale.lblToDate),
                        suffix: ic_category.iconImage(size: 10).paddingAll(14),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context, 
                            initialDate: toDateController.text != '' ? 
                            DateTime.parse(toDateController.text)
                            : DateTime.now(), 
                            firstDate: DateTime(2000), 
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                                return Theme(
                                 data: Theme.of(context).copyWith(
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: textPrimaryColor, // button text color
                                      ),
                                    ),
                                  ),                                               
                                  child: child!,
                                );
                              },
                            );
                          if(pickedDate != null ){
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                              setState(() {
                                toDateController.text = formattedDate; //set output date to TextField value. 
                              });
                              _dateChanged();
                          }
                        },
                      ),
                   16.height,
                    snap.isEmpty?
               BackgroundComponent(
            text: locale.lblNoDataFound,
            showLoadingWhileNotLoading: true,
              ).paddingOnly(top: 16, left: 16)
            :TransactionsReportDataTable(transactions: snap),
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



class TransactionsReportDataTable extends StatelessWidget {
  final List<TransactionModel> transactions;
  const TransactionsReportDataTable({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 700,
          columns: [
            DataColumn2(
              label: Text(locale.lblVoucher),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text(locale.lblVoucherNo,),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Text(locale.lblDate,),
            ),
            DataColumn(
              label: Text(locale.lblDebit),
              numeric: true,
            ),
            DataColumn(
              label: Text(locale.lblCredit),
              numeric: true,
            ),
            DataColumn(
              label: Text(locale.lblBalance),
              numeric: true,
            ),
          ],
          rows: List<DataRow>.generate(
              transactions.length,
              (index) => DataRow(cells: [
                    DataCell(Text(transactions[index].voucher)),
                    DataCell(Text(transactions[index].voucherNo ?? '')),
                    DataCell(Text(transactions[index].date ?? '')),
                    DataCell(Text(transactions[index].debit.toString())),
                    DataCell(Text(transactions[index].credit.toString())),
                    DataCell(Text(transactions[index].balance.toString()))
                  ]))),
    );
  }
}