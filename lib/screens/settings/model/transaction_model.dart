class TransactionModel{
  late String? date;
  late String voucher;
  late String? voucherNo;
  late double debit;
  late double credit;
  late double balance;

  TransactionModel.fromJson(Map json){
    this.date = json['posting_date'];
    if (["'Opening'", "'Closing (Opening + Total)'", "'Total'"].indexOf(json['account']) >= 0  ){
       this.voucher = json['account'];
       this.voucher = this.voucher.replaceAll("'", "");
    }else{
      this.voucher = json['voucher_type'];
    }
    this.voucherNo = json['voucher_no'];
    this.debit = json['debit'];
    this.credit = json['credit'];
    this.balance = json['balance'];
  }
}