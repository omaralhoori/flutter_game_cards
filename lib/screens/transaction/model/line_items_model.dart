class LineItemModel {
  String? productId;
  String? quantity;

  LineItemModel({this.productId, this.quantity});
}

class LineItemsRequest {
  String? productId;
  String? quantity;

  LineItemsRequest({this.productId, this.quantity});

  factory LineItemsRequest.fromJson(Map<String, dynamic> json) {
    return LineItemsRequest(productId: json['product_id'], quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    return data;
  }
}
