import 'package:flutter/material.dart';
import 'package:resturent_app/models/foodItem.dart';
import 'package:resturent_app/models/foodOrder.dart';
import 'package:resturent_app/services/databaseService.dart';
import 'package:resturent_app/utils/common.dart';

class CartScreen extends StatefulWidget {
  final FoodOrder order;
  final Function onOrderChanged;
  CartScreen(this.order, this.onOrderChanged);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.order.foodItems.length == 0
          ? null
          : SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width * 0.5,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  showLoading(context);
                  var res = await DatabaseService().orderFood(widget.order);
                  Navigator.of(context).pop();
                  var msg = res ? 'Order sent !' : 'There was an error';
                  showOrderStatus(context, msg, widget.order.tableId);
                },
                icon: Icon(
                  Icons.food_bank,
                  size: 35,
                ),
                label: Container(
                  child: Center(
                      child: Text(
                    'Order',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  )),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: FutureBuilder<List<FoodItem>>(
            future: DatabaseService().getFoodItems(),
            builder: (context, snapshot) {
              List<FoodItem> list = snapshot.data;
              var total = 0;
              var items = 0;
              if (!snapshot.hasData)
                return Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                );
              if (list.isNotEmpty) {
                var foodIds =
                    widget.order.foodItems.map((e) => e.foodId).toList();
                list.retainWhere((element) => foodIds.contains(element.id));
                widget.order.foodItems.forEach((e) {
                  total += list
                          .firstWhere((element) => element.id == e.foodId)
                          .price *
                      e.quantity;
                  items += e.quantity;
                });
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cart',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 60,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 3,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Rs: $total',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28,
                                ),
                              ),
                              Text(
                                'Number of Items : $items',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: ListView(
                          children: list.isEmpty
                              ? [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      'Cart is empty',
                                      style: TextStyle(fontSize: 30),
                                    )),
                                  )
                                ]
                              : list
                                  .map((e) => foodItem(e, list.indexOf(e),
                                      isLast:
                                          list.indexOf(e) == list.length - 1))
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget foodItem(FoodItem item, int index, {bool isLast = false}) {
    return Padding(
      padding: isLast
          ? const EdgeInsets.only(bottom: 100)
          : const EdgeInsets.only(bottom: 10),
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
                      widget.order.foodItems[index].quantity++;
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
                        '${widget.order.foodItems[index].quantity}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  normalButton(
                    () => setState(() {
                      if (widget.order.foodItems[index].quantity > 1)
                        widget.order.foodItems[index].quantity--;
                    }),
                    '-',
                    width: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.red,
                  ),
                  normalButton(
                    () {
                      widget.order.foodItems.removeAt(index);
                      widget.onOrderChanged(widget.order);
                      setState(() {});
                    },
                    'Remove',
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: Colors.red,
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
