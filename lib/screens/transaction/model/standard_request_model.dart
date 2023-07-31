import 'dart:convert';
import 'dart:io';

import 'package:bookkart_flutter/screens/transaction/model/customer_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:http/http.dart';

import '../../../models/sub_account.dart';
import 'customization_model.dart';

class StandardRequest {
  String txRef;
  String amount;
  Customization customization;
  Customer customer;
  bool isTestMode;
  String publicKey;
  String paymentOptions;
  String redirectUrl;
  String? currency;
  String? paymentPlanId;
  List<SubAccount>? subAccounts;
  Map<dynamic, dynamic>? meta;

  StandardRequest(
      {required this.txRef,
      required this.amount,
      required this.customer,
      required this.paymentOptions,
      required this.customization,
      required this.isTestMode,
      required this.publicKey,
      required this.redirectUrl,
      this.currency,
      this.paymentPlanId,
      this.subAccounts,
      this.meta});

  String toString() => jsonEncode(this._toJson());

  /// Converts this instance to json
  Map<String, dynamic> _toJson() {
    return {
      "tx_ref": this.txRef,
      "publicKey": this.publicKey,
      "amount": this.amount,
      "currency": this.currency,
      "payment_options": this.paymentOptions,
      "payment_plan": this.paymentPlanId,
      "redirect_url": this.redirectUrl,
      "customer": this.customer.toJson(),
      "subaccounts": this.subAccounts?.map((e) => e.toJson()).toList(),
      "meta": this.meta,
      "customizations": customization.toJson()
    };
  }

  /// Executes network call to initiate transactions
  Future<StandardResponse> execute(Client client) async {
    final url = getBaseUrl(this.isTestMode) + STANDARD_PAYMENT;
    final uri = Uri.parse(url);
    try {
      final response = await client.post(uri, headers: {HttpHeaders.authorizationHeader: this.publicKey, HttpHeaders.contentTypeHeader: 'application/json'}, body: json.encode(this._toJson()));
      final responseBody = json.decode(response.body);
      if (responseBody["status"] == "error") {
        throw TransactionError(responseBody["message"] ?? "An unexpected error occurred. Please try again.");
      }
      return StandardResponse.fromJson(responseBody);
    } catch (error) {
      throw (error);
    }
  }
}

class TransactionError implements Exception {
  String message;

  TransactionError(this.message);

  @override
  String toString() => this.message;
}

class StandardResponse {
  String? status;
  String? message;
  StandardResponseData? data;

  StandardResponse({this.status, this.data, this.message});

  StandardResponse.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.data = StandardResponseData.fromJson(json["data"]);
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() {
    return {"status": this.status, "message": this.message, "data": this.data?.toJson()};
  }
}

class StandardResponseData {
  String? link;

  StandardResponseData([this.link = ""]);

  StandardResponseData.fromJson(Map<String, dynamic> json) {
    this.link = json["link"];
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() {
    return {"link": this.link};
  }
}
