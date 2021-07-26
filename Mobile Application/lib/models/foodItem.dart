class FoodItem {
  String id,category, name, imageUrl, ingrediants, nutritions;
  int price,orderCount;

  FoodItem();

  FoodItem.fromMap(Map<String, dynamic> map) {
    orderCount = map["orderCount"];
    category = map["category"];
    imageUrl = map["imageURL"];
    ingrediants = map["ingrediants"];
    nutritions = map["nutritions"];
    name = map["food_item"];
    price = map["price"];
    id = map["id"];
  }
}
