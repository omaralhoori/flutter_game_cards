import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/screens/settings/model/recharge_model.dart';
import 'package:bookkart_flutter/screens/settings/model/transaction_model.dart';

Future<String> getRechargeBalanceRestApi(Map<String, dynamic> request) async {

  appStore.setLoading(true);
  return await responseHandler(await APICall().postMethod("erpnext.api.recharge.create_balance_recharge", request)).then((value) async {
    appStore.setLoading(false);
    if (value['message'] != null && value['message']['success_key'] == 1){
    return value['message']['message'];
    }else if(value['message'] != null  && value['message']['success_key'] == 0){
      return value['message']['error'];
    }
    throw 'Failed';
  }).catchError((e, s) {
    appStore.setLoading(false);
    throw e;
  });
}
Future<bool> getShareRecommendationRestApi(Map<String, dynamic> request) async {

  appStore.setLoading(true);
  return await responseHandler(await APICall().postMethod("erpnext.api.data.share_recommendation", request)).then((value) async {
    appStore.setLoading(false);
    if (value['message'] != null && value['message']['success_key'] == 1){
    return true;
    }
    throw 'Failed';
  }).catchError((e, s) {
    appStore.setLoading(false);
    throw e;
  });
}

Future<List<TransactionModel>> getTransactionsReportRestApi(Map<String, dynamic> request) async {
  List<TransactionModel> transactions = [];
  appStore.setLoading(true);
  final value =  await responseHandler(await APICall().postMethod("erpnext.api.data.get_transactions_report", request));
    appStore.setLoading(false);
    if (value['message'] != null){
      value['message'].forEach((element) {
    transactions.add(TransactionModel.fromJson(element));
     });
    }
  return transactions;
}

Future<List<RechargeModel>> getRechargeReportRestApi(Map<String, dynamic> request) async {
  List<RechargeModel> transactions = [];
  appStore.setLoading(true);
  final value =  await responseHandler(await APICall().postMethod("erpnext.api.data.get_recharge_report", request));
    appStore.setLoading(false);
    if (value['message'] != null){
      value['message'].forEach((element) {
    transactions.add(RechargeModel.fromJson(element));
     });
    }
  return transactions;
}
