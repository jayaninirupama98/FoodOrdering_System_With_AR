class FoodOrder {
  List<OrderItem> foodItems;
  String tableId;

  FoodOrder() {
    foodItems = [];
  }

  toMap() {
    var map = Map<String, dynamic>();
    map['foodItems'] = foodItems.map((e) => e.toMap()).toList();
    map['tableId'] = tableId;
    map['status'] = 'new';
    return map;
  }
}

class OrderItem {
  String foodId;
  int quantity;

  OrderItem();

  toMap() {
    var map = Map<String, dynamic>();
    map['foodId'] = foodId;
    map['quantity'] = quantity;
    return map;
  }
}
