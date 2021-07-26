import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resturent_app/models/categories.dart';
import 'package:resturent_app/models/foodItem.dart';
import 'package:resturent_app/models/foodOrder.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> orderFood(FoodOrder order) async {
    try {
      await firestore.collection('orders').add(order.toMap());
      for (int i = 0; i < order.foodItems.length; i++) {
        var data = await firestore
            .collection('Foodmenu')
            .doc(order.foodItems[i].foodId)
            .get();
        FoodItem item = FoodItem.fromMap(data.data());
        var orderCount = (item.orderCount ?? 1) + 1;
        await firestore
            .collection('Foodmenu')
            .doc(order.foodItems[i].foodId)
            .update({'orderCount': orderCount});
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      List<Category> list = [];
      var res = await firestore.collection('categories').get();
      res.docs.forEach((element) {
        var data = element.data();
        data['id'] = element.id;
        list.add(Category.fromMap(data));
      });
      return list;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<FoodItem>> getFoodItems() async {
    try {
      List<FoodItem> list = [];
      var res = await firestore.collection('Foodmenu').get();
      res.docs.forEach((element) {
        var data = element.data();
        data['id'] = element.id;
        list.add(FoodItem.fromMap(data));
      });
      return list;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<FoodItem>> getPopularFoods() async {
    try {
      List<FoodItem> list = [];
      var res = await firestore
          .collection('Foodmenu')
          .orderBy('orderCount', descending: true)
          .limit(10)
          .get();

      res.docs.forEach((element) {
        var data = element.data();
        data['id'] = element.id;
        list.add(FoodItem.fromMap(data));
      });
      return list;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
