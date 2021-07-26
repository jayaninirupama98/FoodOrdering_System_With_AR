import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:resturent_app/uis/foodScreen.dart';

Widget normalButton(Function onPressed, String title,
    {double width = 120, double height = 70, Color color}) {
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 28,
        ),
      ),
      style:
          ElevatedButton.styleFrom(padding: EdgeInsets.all(10), primary: color),
    ),
  );
}

Widget inputBox(
  Function onChanged,
  String label, {
  double width = 300,
  double height = 70,
  TextInputType textInputType,
  List<TextInputFormatter> inputFormatters,
  String initialValue,
}) {
  return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: initialValue == null
            ? null
            : TextEditingController.fromValue(
                new TextEditingValue(
                  text: initialValue,
                  selection:
                      new TextSelection.collapsed(offset: initialValue.length),
                ),
              ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: height / 2,
        ),
        keyboardType: textInputType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: Colors.grey[300],
          filled: true,
          hintText: label,
          border: InputBorder.none,
        ),
      ));
}

showLoading(BuildContext context) {
  showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Center(
              child: Text("Loading",
                  style: TextStyle(
                    color: Color.fromRGBO(39, 150, 201, 1),
                  )),
            ),
            content: Container(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            ));
      });
}

showOrderStatus(BuildContext context,String msg, String tableId) {
  double _height = MediaQuery.of(context).size.height * 0.00125;
  showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          title: Center(
            child: Text("Order Status",
                style: TextStyle(
                  color: Color.fromRGBO(39, 150, 201, 1),
                )),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Text(msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(39, 150, 201, 1),
                      ))),
              SizedBox(
                height: _height * 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: normalButton(
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            FoodScreen(tableId))),
                    'Okay'),
              )
            ],
          ),
        );
      });
}
