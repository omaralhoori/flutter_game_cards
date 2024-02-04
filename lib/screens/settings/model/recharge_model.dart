class RechargeModel{
  late String name;
  late String posingDate;
  late String postingTime;
  late String transactionType;
  late double amount;

  RechargeModel.fromJson(Map json){
    this.name = json['name'];
    this.transactionType = json['entry_type'];
    this.amount = json['recharge_amount'];
    String creation = json['creation'];
    DateTime dateTime = DateTime.parse(creation);
    this.postingTime = "${dateTime.hour}:${dateTime.minute}";
    this.posingDate = creation.split(" ")[0];//"${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }
}