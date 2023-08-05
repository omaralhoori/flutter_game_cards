import 'package:nb_utils/nb_utils.dart';

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
  int qty=0;

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
  Map<String, dynamic> toJson(){
    return {
      "name": this.id,
      "item_name": this.name,
      "item_group": this.category,
      "brand": this.subcategory,
      "image": this.image,
      "price_list_rate": this.price.validate().toString(),
       "projected_qty": projectedQty.validate().toString(),
      "currency": this.currency,
     
    };
  }
}