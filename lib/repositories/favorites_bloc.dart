import 'dart:async';

import 'package:collection/collection.dart';
import 'package:estudo_api4/repositories/products_favorited_bloc.dart';
import 'package:provider/provider.dart';

import '../models/favorite_model.dart';
import 'favorites_repository.dart';

class FavoritesBloc {
  List<Favorite> faves = [];
  final _streamController = StreamController<List<Favorite>>.broadcast();
  Stream get outFav => _streamController.stream;
  FavoritesRepository favoritesRepository = FavoritesRepository();

  void toggleFavorite(String id) async {
    faves = await favoritesRepository.getFaves();

    Favorite newF = Favorite(id: id);

    bool found =
        faves.firstWhereOrNull((k) => k.id == id) != null ? true : false;
    if (found) {
      faves.removeWhere((e) => e.id == newF.id.toString());
    } else {
      faves.add(newF);
    }

    favoritesRepository.saveFaves(faves);

    _streamController.add(faves);
  }

  dispose() {
    _streamController.close();
  }
}
