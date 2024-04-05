import 'dart:async';
import 'package:estudo_api4/models/favorite_model.dart';
import 'package:estudo_api4/repositories/favorites_repository.dart';
import 'package:estudo_api4/repositories/products_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';

class Favoritedbloc extends ChangeNotifier {
  //final _streamController = StreamController<List<Product>>.broadcast();
  FavoritesRepository favoritesRepository = FavoritesRepository();

  List<Favorite> faves = [];
  List<Product> faveProducts = [];

  //Stream get stream => _streamController.stream;

  void getFavorited() async {
    faveProducts = [];
    try {
      List<Product> products = await ProductsRepository.getProductsApi();

      List<Favorite> faves = await favoritesRepository.getFaves();

      if (faves.isNotEmpty) {
        for (var img in products) {
          for (var frnd in faves) {
            if (img.id.toString() == frnd.id.toString()) {
              faveProducts.add(img);
            }
          }
        }
      }
      notifyListeners();
      //_streamController.add(faveProducts);
    } on Exception catch (e) {
      //_streamController.addError(e);
      notifyListeners();
    }
  }
}
