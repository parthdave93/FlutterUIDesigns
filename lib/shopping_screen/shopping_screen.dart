import 'package:flutter/material.dart';

class ShoppingScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ShoppingScreenState();
  }
}

class ShoppingScreenState extends State<ShoppingScreen>{
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: ListView.builder(),
      );
  }
}