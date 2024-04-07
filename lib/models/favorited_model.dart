import 'package:collection/collection.dart';
import 'package:estudo_api4/models/favorite_model.dart';
import 'package:estudo_api4/repositories/favorites_repository.dart';
import 'package:estudo_api4/repositories/products_repository.dart';
import 'package:mobx/mobx.dart';
import '../models/product_model.dart';

part 'favorited_model.g.dart';

class FavoritedModel = _FavoritedModel with _$FavoritedModel;

abstract class _FavoritedModel with Store {
  FavoritesRepository favoritesRepository = FavoritesRepository();

  //List<Favorite> faves = [];

  @observable
  String error = '';

  @observable
  List<Product> faveProducts = [];

  @action
  getFavorited() async {
    try {
      error = '';
      faveProducts = [];

      List<Product> products = await ProductsRepository.getProductsApi();

      List<Favorite> faves = await favoritesRepository.getFaves();

      if (faves.isNotEmpty) {
        for (var img in products) {
          for (var frnd in faves) {
            if (img.id.toString() == frnd.id.toString()) {
              var isFav =
                  faves.firstWhereOrNull((k) => k.id == img.id.toString()) !=
                          null
                      ? true
                      : false;
              if (isFav == false) {
                faveProducts.add(img);
              }
            }
          }
        }
      } else {
        faveProducts = [];
      }
    } on Exception catch (e) {
      error = e.toString();
    }
  }
}
