import 'dart:async';

import 'package:estudo_api4/repositories/favorites_repository.dart';
import 'package:estudo_api4/repositories/products_repository.dart';

import '../models/product_model.dart';

class ProductsBloc {
  final StreamController _streamController = StreamController<List<Product>>();
  FavoritesRepository favoritesRepository = FavoritesRepository();

  Stream get stream => _streamController.stream;

  getProducts() async {
    try {
      List<Product> products = await ProductsRepository.getProductsApi();

      favoritesRepository.getFaves().then((value) {
        favoritesRepository.favoritos = value!;
      });

      _streamController.add(products);
    } on Exception catch (e) {
      _streamController.addError(e);
    }
  }

  void dispose() {
    _streamController.close();
  }
}
