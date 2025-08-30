import 'dart:convert';

import 'package:crud_assignment/Models/product_models.dart';
import 'package:crud_assignment/all_screens/add_new_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Utils/uris.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ///Create a list for store product
  List<Product_models> _productList = [];
  bool _getProductInProgress =  false;

  @override
  void initState() {
    super.initState();
    _getProductList();
  }




  ///API calling
  Future<void> _getProductList() async{
    _productList.clear();
    _getProductInProgress = true;
    setState(() {});


    Uri uri = Uri.parse(Urls.getProductsUrl);
    Response response = await get(uri);

    debugPrint(response.statusCode.toString());
    debugPrint(response.body);

    if(response.statusCode == 200){
      final decodedJson = jsonDecode(response.body);
      for(Map<String, dynamic> productjson in decodedJson['data']){
        Product_models productmodel = Product_models.fromJson(productjson);
        ///add product int list

        _productList.add(productmodel);
      }
    }
    _getProductInProgress = false;
    setState(() {});

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Product App with CRUD Application",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

        actions: [
          IconButton(onPressed: (){
            _getProductList();
          }, icon: Icon(Icons.refresh))
        ],
      ),

      body: Visibility(
        visible: _getProductInProgress == false,
        replacement: Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.separated(
          itemCount: _productList.length,
            itemBuilder: (context,index){
            return product_item(product: _productList[index],
              refreshProductList: (){
              _getProductList();
              }
            );
            },

          separatorBuilder: (context,index){
            return Divider(
              indent: 20,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewProductPage()));
      },
        icon: Icon(Icons.add),
        label: Text('Add Product'),
      ),

    );
  }
}


