
// "_id": "68af0486dd287e3f18a266f3",
// "ProductName": "Manggo",
// "ProductCode": 256514512103,
// "Img": "sfsa",
// "Qty": 5,
// "UnitPrice": 140,
// "TotalPrice": 700

class Product_models{
  late String id;
  late String name;
  late int code;
  late String image;
  late int quantity;
  late int unitPrice;
  late int totalPrice;



  Product_models.fromJson(Map<String,dynamic>productjson){
    id = productjson['_id'];
    name = productjson['ProductName'];
    code = productjson['ProductCode'];
    image = productjson['Img'];
    quantity = productjson['Qty'];
    unitPrice = productjson['UnitPrice'];
    totalPrice = productjson['TotalPrice'];

  }

}