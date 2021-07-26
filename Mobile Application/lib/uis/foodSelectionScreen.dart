import 'package:flutter/material.dart';
import 'package:resturent_app/models/foodItem.dart';
import 'package:resturent_app/models/foodOrder.dart';
import 'package:resturent_app/services/databaseService.dart';
import 'package:resturent_app/uis/arScreen.dart';
import 'package:resturent_app/uis/cartScreen.dart';
import 'package:resturent_app/utils/common.dart';

class FoodSelectionScreen extends StatefulWidget {
  final String category;
  final String tableId;
  final FoodOrder foodOrder;
  final Function onOrderChange;
  final String search;
  FoodSelectionScreen(this.tableId, this.foodOrder, this.onOrderChange,
      {this.category, this.search});
  @override
  _FoodSelectionScreenState createState() => _FoodSelectionScreenState();
}

List<int> _quantities;

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  @override
  void initState() {
    _quantities = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<FoodItem>>(
            future: DatabaseService().getFoodItems(),
            builder: (context, snapshot) {
              List<FoodItem> list = snapshot.data;
              if (!snapshot.hasData)
                return Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                );
              if (list.isNotEmpty) {
                if (_quantities.isEmpty)
                  _quantities = List<int>.filled(list.length, 1);
                if (widget.category != null) {
                  list.retainWhere(
                      (element) => element.category == widget.category);
                }
                if (widget.search != null) {
                  list.retainWhere(
                      (element) => element.name.contains(widget.search));
                }
              }
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 60,
                  top: 10,
                  right: 10,
                  left: 10,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          widget.category == null
                              ? widget.search == ""
                                  ? "Food List"
                                  : "Results for ${widget.search}"
                              : widget.category,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 60,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: list
                            .map((e) => foodCard(e, list.indexOf(e)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget foodCard(FoodItem item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor, width: 3),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                item.imageUrl ??
                    'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${item.name}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 34,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Ingrediants : ${item.ingrediants}',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Nutritions : ${item.nutritions}',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 5,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: normalButton(
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ARScreen(item.imageUrl),
                    ),
                  ),
                  'Augmented View',
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Rs: ${item.price}',
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  normalButton(
                    () => setState(() {
                      _quantities[index]++;
                    }),
                    '+',
                    width: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.green,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 70,
                    child: Center(
                      child: Text(
                        '${_quantities[index]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  normalButton(
                    () => setState(() {
                      if (_quantities[index] > 1) _quantities[index]--;
                    }),
                    '-',
                    width: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.red,
                  ),
                  normalButton(
                    () {
                      OrderItem foodItem = OrderItem();
                      foodItem.foodId = item.id;
                      foodItem.quantity = _quantities[index];
                      var foodIds = widget.foodOrder.foodItems
                          .map((e) => e.foodId)
                          .toList();
                      if (foodIds.contains(item.id))
                        widget.foodOrder.foodItems.removeWhere(
                            (element) => element.foodId == item.id);
                      widget.foodOrder.foodItems.add(foodItem);
                      widget.onOrderChange(widget.foodOrder);
                      setState(() {});
                    },
                    'Add',
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
