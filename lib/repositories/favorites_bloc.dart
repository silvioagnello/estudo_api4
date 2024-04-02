import 'dart:async';

import 'package:estudo_api4/models/favorite_model.dart';
import 'package:estudo_api4/repositories/favorites_repository.dart';
import 'package:estudo_api4/repositories/products_repository.dart';

import '../models/product_model.dart';

class Favoritesbloc {
  final StreamController _streamController = StreamController<List<Product>>();
  FavoritesRepository favoritesRepository = FavoritesRepository();

  Stream get stream => _streamController.stream;

  getFavorites() async {
    try {
      List<Product> products = await ProductsRepository.getProductsApi();

      favoritesRepository.getFaves().then((value) {
        favoritesRepository.favoritos = value!;
      });

      List<Product> faves = [];
      if (favoritesRepository.favoritos.isNotEmpty) {
        for (var img in products) {
          for (var frnd in favoritesRepository.favoritos) {
            if (img.id.toString() == frnd.id.toString()) {
              faves.add(img);
            }
          }
        }
      }

      _streamController.add(faves);
    } on Exception catch (e) {
      _streamController.addError(e);
    }
  }

  void dispose() {
    _streamController.close();
  }
}
