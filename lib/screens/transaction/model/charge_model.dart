class ChargeResponse {
  String? status;
  bool? success;
  String? transactionId;
  String? txRef;

  ChargeResponse({this.status, this.success, this.transactionId, this.txRef});

  ChargeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] == null ? TransactionStatus.ERROR : json['status'];
    success = json['success'] == null ? false : json['success'];
    transactionId = json['transaction_id'];
    txRef = json['tx_ref'];
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['transaction_id'] = this.transactionId;
    data['tx_ref'] = this.txRef;
    return data;
  }
}

class TransactionStatus {
  static const SUCCESSFUL = "successful";
  static const CANCELLED = "cancelled";
  static const ERROR = "error";
}
