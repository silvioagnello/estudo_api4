import 'dart:async';
import 'package:collection/collection.dart';
import 'package:estudo_api4/models/favorite_model.dart';
import 'package:estudo_api4/repositories/favorites_repository.dart';
import 'package:estudo_api4/repositories/products_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';

class Favoritedbloc extends ChangeNotifier {
  FavoritesRepository favoritesRepository = FavoritesRepository();

  List<Favorite> faves = [];
  List<Product> faveProducts = [];

  void getFavorited() async {
    try {
      List<Product> products = await ProductsRepository.getProductsApi();
      List<Favorite> faves = await favoritesRepository.getFaves();

      faveProducts = [];

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
    } on Exception catch (e) {
      notifyListeners();
    }
  }
}
