class InvoiceModel{
    late String invoiceId;
    late String postingDate;
    late String postingTime;
    late double grandTotal;
    late String itemCode;
    late double itemRate;
    late int qty;
    late String serialNo;
    late String? image;

    InvoiceModel({required this.invoiceId, required this.postingDate, required this.postingTime,
      required this.grandTotal, required this.itemCode, 
      required this.image, required this.itemRate, 
      required this.qty, required this.serialNo
    });

    InvoiceModel.fromJson(Map<String, dynamic> json, this.serialNo){
      this.invoiceId = json['name'];
      this.grandTotal = json['grand_total'];
      this.postingDate = json['posting_date'];
      this.postingTime = json['posting_time'].split(".")[0];
      this.itemCode = json['item_code'];
      this.itemRate = json['price_list_rate'];
      this.qty = json['qty'].toInt();
      this.image = json['image'];
    } 
}