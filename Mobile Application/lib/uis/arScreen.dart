import 'package:flutter/material.dart';

class ARScreen extends StatelessWidget {
  final String imageUrl;
  ARScreen(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan this image using our AR app for augmented view'),
      ),
      body: SafeArea(
        child: Center(
          child: Image.network(
            imageUrl,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
