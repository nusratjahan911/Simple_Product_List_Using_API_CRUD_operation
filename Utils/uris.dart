class Urls{
  static const String _baseUrl = 'http://35.73.30.144:2008/api/v1';

  static const String createProductsUrl = '$_baseUrl/CreateProduct';

  static const String getProductsUrl = '$_baseUrl/ReadProduct';

  static String updateProductsUrl (String id){
    return '$_baseUrl/UpdateProduct/$id';
  }

  static String deleteProductsUrl(String id){
    return '$_baseUrl/DeleteProduct/$id';
  }
}