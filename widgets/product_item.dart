import 'package:crud_assignment/Models/product_models.dart';
import 'package:crud_assignment/all_screens/update_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Utils/uris.dart';

class product_item extends StatefulWidget {
  const product_item({
    super.key, required this.product, required this.refreshProductList,
  });

  final Product_models product;
  final VoidCallback refreshProductList;

  @override
  State<product_item> createState() => _product_itemState();
}

class _product_itemState extends State<product_item> {

  bool _deleteInprogress = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        width: 40,
        widget.product.image, errorBuilder: (_, __, ___) {
        return Icon(Icons.error_outline, size: 40);
      },
      ),
      title: Text(widget.product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Code: ${widget.product.code}"),
          Row(
            children: [
              Text("Quantity :${widget.product.quantity}"),
              SizedBox(width: 10),
              Text("Unit Price: ${widget.product.unitPrice}"),
            ],
          )
        ],
      ),


      trailing: Visibility(
        visible: _deleteInprogress == false,
        replacement: CircularProgressIndicator(),
        child: PopupMenuButton<ProductOptions>(
          itemBuilder: (context) {
            return [
              PopupMenuItem(value: ProductOptions.update,
                  child: Text(" Update ", style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),)),
              PopupMenuItem(value: ProductOptions.delete,
                  child: Text(" Delete ", style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),)),
            ];
          },

          onSelected: (ProductOptions selectOption) {
            if (selectOption == ProductOptions.delete) {
              _deleteProduct();
            } else if (selectOption == ProductOptions.update) {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  UpdateProductPage(
                    product: widget.product,
                  )
              )
              );
            }
          },

        ),
      ),
    );
  }


  ///API calling for delete

  Future<void> _deleteProduct() async {
    _deleteInprogress = true;

    Uri uri = Uri.parse(Urls.deleteProductsUrl(widget.product.id));
    Response response = await get(uri);

    debugPrint(response.statusCode.toString());
    debugPrint(response.body);

    if (response.statusCode == 200) {
      widget.refreshProductList();
    }
    _deleteInprogress = false;
    setState(() {});
  }
}

enum ProductOptions {
  update,
  delete
}