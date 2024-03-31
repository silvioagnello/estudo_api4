import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:estudo_api4/repositories/prefs.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/favorite_model.dart';

class FavoritesRepository extends Model {
  static final FavoritesRepository _instance = FavoritesRepository.internal();
  factory FavoritesRepository() => _instance;
  FavoritesRepository.internal();

  List<Favorite> favoritos = [];

  saveFaves(List<Favorite> favs) async {
    String data = jsonEncode(favs);
    Prefs.setString('my_favorites', data);
  }

  getFav(p) {
    var isFav =
        favoritos.firstWhereOrNull((k) => k.id == p.id.toString()) != null
            ? true
            : false;
    notifyListeners();
    return isFav;
  }

  Future<List<Favorite>?> getFaves() async {
    Map<String, dynamic> newFave = {};
    var data = (await Prefs.getString('my_favorites'));
    if (data != '') {
      final List jsonDecoded = json.decode(data) as List;
      return jsonDecoded.map((e) => Favorite.fromJson(e)).toList();
    } else {
      Favorite newF = Favorite(id: '123');
      favoritos.add(newF);
      return favoritos;
    }
  }
}
