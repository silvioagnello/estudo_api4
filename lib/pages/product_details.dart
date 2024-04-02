import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:estudo_api4/models/favorite_model.dart';
import 'package:estudo_api4/models/product_model.dart';
import 'package:estudo_api4/repositories/favorites_repository.dart';
import 'package:estudo_api4/repositories/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({required this.product, super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  FavoritesRepository favoritesRepository = FavoritesRepository();

  List<Favorite> favoritos = [];
  Color colores = Colors.grey;
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    favoritesRepository.getFaves().then((value) {
      setState(() {
        favoritesRepository.favoritos = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name.toString()),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    return Center(
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                //color: Colors.cyan,
                height: 300,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  //child: Image.asset('assets/images/place_holder.jpg'),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: 'https:${widget.product.apiFeaturedImage}',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _grupoLinha(),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                    '${widget.product.description}+${widget.product.description}' ??
                        ''),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding _grupoLinha() {
    Product p = widget.product;
    var isFav = favoritesRepository.getFav(p);

    colores = isFav ? Colors.red : Colors.grey;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(p.name ?? ''),
                ),
                //const Text(' - '),
                Text(p.id.toString()),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(p.brand ?? ''),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text('-'),
                      ),
                      Text(p.category ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      isFav = _onClickFavorite(p, isFav) ?? false;
                    },
                    icon: Icon(Icons.favorite, size: 30, color: colores)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      size: 30,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  _onClickFavorite(p, isFav) {
    Favorite newF = Favorite(id: p.id.toString());
    if (isFav == false) {
      favoritesRepository.favoritos.add(newF);
    } else {
      favoritesRepository.favoritos
          .removeWhere((e) => e.id.toString() == newF.id.toString());
    }

    favoritesRepository.saveFaves(favoritesRepository.favoritos);

    bool c = !isFav; // <=== FAVORITAR
    setState(() {
      colores = c ? Colors.red : Colors.grey;
    });

    return c;
  }
}
