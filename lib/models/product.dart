class VariantModel {
  String name;
  String id;
  String option;

  VariantModel({
    required this.id,
    required this.name,
    required this.option,
  });
}

class ProductModel {
  String id;
  String name;
  String description;
  String price;

  List<VariantModel> variants;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.variants,
  });
}
