import 'package:flutter/material.dart';
import 'package:resturent_app/models/categories.dart';
import 'package:resturent_app/models/foodItem.dart';
import 'package:resturent_app/models/foodOrder.dart';
import 'package:resturent_app/services/databaseService.dart';
import 'package:resturent_app/uis/cartScreen.dart';
import 'package:resturent_app/uis/foodSelectionScreen.dart';
import 'package:resturent_app/utils/common.dart';

class FoodScreen extends StatefulWidget {
  final String tableId;
  FoodScreen(this.tableId);
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final PageController controller = PageController(initialPage: 0);
  int _selectedIndex = 0;
  FoodOrder _foodOrder;
  String _search;
  Category _category;

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        _search = "";
        _category = null;
      }
      controller.jumpToPage(index);
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _foodOrder = FoodOrder();
    _foodOrder.tableId = widget.tableId;
    _search = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Foods',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: <Widget>[
            FutureBuilder<List<FoodItem>>(
                future: DatabaseService().getPopularFoods(),
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
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'Welcome',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 60,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'What would you like to eat',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  inputBox((val) => _search = val, 'Search',
                                      initialValue: _search,
                                      width: MediaQuery.of(context).size.width *
                                          0.6),
                                  normalButton(
                                      () => setState(() {
                                            _category = null;
                                            _selectedIndex = 2;
                                            controller.jumpToPage(2);
                                          }),
                                      'Search',
                                      width: MediaQuery.of(context).size.width *
                                          0.3),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Most Popular',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 26,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: list
                                            .map((e) => popularFoodCard(e))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Main Categories',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 26,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    FutureBuilder<List<Category>>(
                                        future:
                                            DatabaseService().getCategories(),
                                        builder: (context, snapshot) {
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: !snapshot.hasData
                                                  ? []
                                                  : snapshot.data
                                                      .map((e) =>
                                                          categoriesCard(e))
                                                      .toList(),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            CartScreen(
              _foodOrder,
              (order) => setState(() {
                _foodOrder = order;
              }),
            ),
            FoodSelectionScreen(
              widget.tableId,
              _foodOrder,
              (order) => setState(() {
                _foodOrder = order;
              }),
              category: _category?.name,
              search: _search,
            ),
          ],
        ),
      ),
    );
  }

  Widget categoriesCard(Category category) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: GestureDetector(
        onTap: () => setState(() {
          _category = category;
          _selectedIndex = 2;
          controller.jumpToPage(2);
        }),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                category.imageURL ??
                    'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
                width: MediaQuery.of(context).size.width * 0.48 + 50,
                height: MediaQuery.of(context).size.width * 0.48,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${category.name}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget popularFoodCard(FoodItem foodItem) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: GestureDetector(
        onTap: () => setState(() {
          _category = null;
          _search = foodItem.name;
          _selectedIndex = 2;
          controller.jumpToPage(2);
        }),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                foodItem.imageUrl ??
                    'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3 + 30,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${foodItem.name}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
              Text(
                'Rs: ${foodItem.price}',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
