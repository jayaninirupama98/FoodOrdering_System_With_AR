import 'package:flutter/material.dart';
import 'package:resturent_app/uis/foodScreen.dart';
import 'package:resturent_app/utils/common.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _tableNumber = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Restaurants App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 60,
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Please Enter a Table Number to Start the App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              inputBox((val) => _tableNumber = val, 'Table Number'),
              SizedBox(
                height: 20,
              ),
              normalButton(() {
                if (_tableNumber.isEmpty)
                  return ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Table number is empty',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  );
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        FoodScreen(_tableNumber)));
              }, 'Start', width: 150),
            ],
          ),
        )),
      ),
    );
  }
}
