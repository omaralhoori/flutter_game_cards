class InvoiceListModel{
  late String id;
  late String postingDate;
  late String? image;
  late int totalQty;
  late double grandTotal;


  InvoiceListModel.fromJson(Map json){
    this.id = json['name'];
    this.postingDate = json['posting_date'];
    this.image =json['image'];
    this.totalQty = json['total_qty'].toInt();
    this.grandTotal = json['grand_total'];
  }
}