import 'dart:convert';

import 'package:crud_assignment/Models/product_models.dart';
import 'package:crud_assignment/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Utils/uris.dart';

class UpdateProductPage extends StatefulWidget {
  const UpdateProductPage({super.key,required this.product});
  
  final Product_models product;

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  bool _updateProductInProgress = false;


  ///key
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  ///controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();



  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _codeController.text = widget.product.code.toString();
    _priceController.text = widget.product.unitPrice.toString();
    _quantityController.text = widget.product.quantity.toString();
    _imageController.text = widget.product.image;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Product",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///Name
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: "product name",
                      labelText: "Product Name",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      )
                  ),

                  ///validation
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Enter Product Name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                ///Code
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _codeController,
                  decoration: InputDecoration(
                      hintText: "product code",
                      labelText: "Product Code",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      )),

                  ///validation
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Enter Product Code";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                ///Quantity
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  controller: _quantityController,
                  decoration: InputDecoration(
                      hintText: "quantity",
                      labelText: "Quantity",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      )),

                  ///validation
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Enter Quantity";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                ///Price
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  decoration: InputDecoration(
                      hintText: "product price",
                      labelText: "Product Price",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      )),

                  ///validation
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Enter Product Price";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                ///Image URL
                TextFormField(
                  controller: _imageController,
                  decoration: InputDecoration(
                    hintText: "image url",
                    labelText: "Image Url",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  ///validation
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Wrong Image url";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                ///Submit Button
                Visibility(
                  visible: _updateProductInProgress == false ,
                  child: FilledButton(
                    onPressed: _onTapUpdateProductButton,
                    child: Text(
                      "Update Product",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




  ///API Calling for update
  Future<void> _onTapUpdateProductButton() async {
    if(_formkey.currentState!.validate() == false){
      print("check validation");
      return;
    }
    print("check");

    _updateProductInProgress = true;
    setState(() {});

    ///Prepare URI to request
    Uri uri = Uri.parse(Urls.updateProductsUrl(widget.product.id));

    ///Prepare data
    int totalPrice = int.parse(_priceController.text) * int.parse(_quantityController.text);
    Map<String, dynamic> requestBody = {
      "ProductName": _nameController.text,
      "ProductCode": int.parse(_codeController.text),
      "Img": _imageController.text,
      "Qty": int.parse(_quantityController.text),
      "UnitPrice":int.parse(_priceController.text),
      "TotalPrice": totalPrice
    };

    ///Request with data
    Response response = await post(
      uri,
      headers: {
        'Content-Type' : 'application/json'
      },
      body: jsonEncode(requestBody)
    );
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);


    if(response.statusCode == 200){
      final decodedJson = jsonDecode(response.body);
      if(decodedJson['status'] == 'success'){
        _clearTextField();
        showSnackbarMessage(context, 'Product Updated Successfully');
      }else{
        String errorMessage = decodedJson['data'];
        showSnackbarMessage(context, errorMessage);
      }
    }
    _updateProductInProgress = false;
    setState(() {});

  }

  void _clearTextField() {
    _nameController.clear();
    _imageController.clear();
    _quantityController.clear();
    _priceController.clear();
    _codeController.clear();
  }

  @override
  void dispoe() {
    _nameController.dispose();
    _codeController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}
