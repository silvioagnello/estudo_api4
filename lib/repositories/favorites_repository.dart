import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:estudo_api4/repositories/prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:scoped_model/scoped_model.dart';

import '../models/favorite_model.dart';

class FavoritesRepository {
  static final FavoritesRepository _instance = FavoritesRepository.internal();
  factory FavoritesRepository() => _instance;
  FavoritesRepository.internal();

  bool _isFav = false;
  bool get isFav => _isFav;

  List<Favorite> favoritos = [];

  saveFaves(List<Favorite> favs) async {
    String data = jsonEncode(favs);
    Prefs.setString('my_favorites', data);
  }

  getFav(p) {
    _isFav = favoritos.firstWhereOrNull((k) => k.id == p.id.toString()) != null
        ? true
        : false;

    return _isFav;
  }

  Future<List<Favorite>> getFaves() async {
    Map<String, dynamic> newFave = {};
    String data = (await Prefs.getString('my_favorites'));
    if (data != '[]') {
      //|| data != '' || data.isNotEmpty) {
      final List jsonDecoded = json.decode(data) as List;
      return jsonDecoded.map((e) => Favorite.fromJson(e)).toList();
    } else {
      favoritos = [];
      Favorite newF = Favorite(id: '123');
      favoritos.add(newF);
      return favoritos;
    }
  }
}
