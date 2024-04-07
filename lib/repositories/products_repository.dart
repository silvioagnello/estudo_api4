import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:estudo_api4/models/product_model.dart';

class ProductsRepository {
  List<Product> products = [];
  static Future<List<Product>> getProductsApi() async {
    List<Product> products = [];
    try {
      final url =
          Uri.parse('https://makeup-api.herokuapp.com/api/v1/products.json');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body) as List;
        // return list.map((e) => Product.fromJson(e)).toList();
        for (Map<String, dynamic> map in list) {
          Product c = Product.fromJson(map);
          if (c.price != null && c.price != "0.0" && c.category != null) {
            products.add(c);
          }
        }
        return products;
      } else {
        return products = baseTest();
      }
    } on Exception catch (e) {
      return products = baseTest();
    }
  }

  static baseTest() {
    List<Product> products = [];
    // await Future.delayed(const Duration(seconds: 2));
    products.add(Product(
        id: 1048, brand: "colourpop", name: "Lippie Pencil", price: "5.0"));
    products.add(Product(
        id: 1047, brand: "colourpop", name: "Blotted Lip", price: "5.5"));
    products.add(Product(
        id: 1046, brand: "colourpop", name: "Lippie Stix", price: "5.5"));
    products.add(Product(
        id: 1045, brand: "colourpop", name: "Foundation", price: "12.0"));
    products.add(
        Product(id: 1044, brand: "boosh", name: "Lipstick", price: "26.0"));
    products.add(Product(
        id: 1043, brand: "deciem", name: "Serum Foundation", price: "6.7"));
    products.add(Product(
        id: 1042, brand: "deciem", name: "Coverage Foundation", price: "6.9"));
    products.add(Product(
        id: 1005, brand: "alva", name: "Liquid Eye Shadow", price: "9.95"));

    return products;
    //throw Exception(e);
  }
}
