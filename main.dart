import 'package:crud_assignment/all_screens/home_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const ProductApp());
}

class ProductApp extends StatelessWidget{
  const ProductApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Product App',
      home:HomeScreen() ,
      theme: ThemeData(
        colorSchemeSeed: Colors.lightGreen
      ),
    );
  }
}