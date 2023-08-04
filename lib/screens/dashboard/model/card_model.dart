class CardModel{
  late String id;
  late String name;
  late String category;
  late String? subcategory;
  late String? description;
  late String? image;
  late double? price;
  late String? currency;
  late int? projectedQty;

  CardModel.fromJson(Map<dynamic, dynamic> json){
    id= json['name'];
    name = json['item_name'];
    category = json['item_group'];
    subcategory = json['brand'];
    image = json['image'];
    price = json['price_list_rate'] != null ? double.parse(json['price_list_rate']) : null;
    currency = json['currency'];
    projectedQty = json['projected_qty'] != null ? int.tryParse(json['projected_qty']) : 0;
  }

}