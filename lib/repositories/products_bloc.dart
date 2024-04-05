import 'dart:async';

import 'package:estudo_api4/repositories/favorites_repository.dart';
import 'package:estudo_api4/repositories/products_repository.dart';
import 'package:flutter/material.dart';

import '../models/favorite_model.dart';
import '../models/product_model.dart';

class ProductsBloc extends ChangeNotifier {
  final StreamController _streamController = StreamController<List<Product>>();
  final StreamController _favesController = StreamController<List<Favorite>>();
  FavoritesRepository favoritesRepository = FavoritesRepository();

  Stream get stream => _streamController.stream;

  getProducts() async {
    try {
      List<Product> products = await ProductsRepository.getProductsApi();
      _streamController.add(products);
    } on Exception catch (e) {
      _streamController.addError(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
