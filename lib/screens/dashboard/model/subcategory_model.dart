class SubcategoryModel{
  late String id;

  SubcategoryModel.fromJson(Map<dynamic, dynamic> json){
    id = json['brand'];
  }
}