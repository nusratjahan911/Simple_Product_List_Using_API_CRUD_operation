import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../widgets/show_snackbar.dart';

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage({super.key});

  @override
  State<AddNewProductPage> createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {

  bool _addProductInProgress = false;

  ///key
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  ///controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add New Product",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
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
                      )),

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
                  visible: _addProductInProgress == false,
                  replacement: Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: FilledButton(
                    onPressed: _onTapAddProductButton,
                    child: Text(
                      "Add Product",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

  Future<void> _onTapAddProductButton() async {
    if (_formkey.currentState!.validate() == false) {
      return;
    }

    _addProductInProgress = true;
    setState(() {});

    ///Prepare URI to Request
    Uri uri = Uri.parse('http://35.73.30.144:2008/api/v1/CreateProduct');
    int totalprice = int.parse(_priceController.text) * int.parse(_quantityController.text);

    ///Prepare Data
    Map<String, dynamic> requestBody = {
      "ProductName": _nameController.text,
      "ProductCode": int.parse(_codeController.text),
      "Img": _imageController.text,
      "Qty": int.parse(_quantityController.text),
      "UnitPrice": int.parse(_priceController.text),
      "TotalPrice": totalprice
    };

    ///Request with Data
    Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody)
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      if (decodedJson['status'] == 'success') {
        _clearTextField();
        showSnackbarMessage(context, 'Product Created Successfully');
      } else {
        String errorMessage = decodedJson['data'];
        showSnackbarMessage(context, errorMessage);
      }
    }

    _addProductInProgress = false;
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
    _priceController.dispose();
    _quantityController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}
