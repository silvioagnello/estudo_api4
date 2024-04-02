import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product_model.dart';
import '../pages/product_details.dart';
import '../repositories/favorites_repository.dart';
import '../repositories/products_bloc.dart';
import '../repositories/products_repository.dart';

class ProductsListView extends StatefulWidget {
  const ProductsListView({super.key});

  @override
  State<ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView>
    with AutomaticKeepAliveClientMixin<ProductsListView> {
  late List<Product>? products;
  ProductsBloc productsBloc = ProductsBloc();
  // final StreamController _streamController = StreamController<List<Product>>();
  FavoritesRepository favoritesRepository = FavoritesRepository();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    productsBloc.getProducts();
  }

  @override
  void dispose() {
    super.dispose();
    productsBloc.dispose();
  } // void getProducts() async {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Future<List<Product>> products = ProductsRepository.getProductsApi();

    return StreamBuilder(
      stream: productsBloc.stream,
      //future: products,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Não foi possível conexão com os dados'),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: Icon(Icons.refresh, size: 50), onPressed: null),
                )
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.connectionState == ConnectionState.none) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.green));
        }

        if (snapshot.hasData) {
          List<Product>? produtos = snapshot.data;
          if (produtos!.isNotEmpty) {
            return _listView(produtos);
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sem dados'),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: IconButton(
                        icon: Icon(Icons.refresh, size: 50), onPressed: null),
                  )
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
      },
    );
  }

  Container _listView(table) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: ScopedModelDescendant<FavoritesRepository>(
        builder: (context, child, model) {
          return ListView.builder(
            itemCount: table.length,
            itemBuilder: (context, index) {
              String valor = '0';
              Product p = table[index];
              String? val = p.price ?? '0.0';
              valor = double.parse(val).toStringAsFixed(2);
              var isFavorited = model.getFav(p);
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      //child: Image.asset('assets/images/place_holder.jpg'),
                      child: CachedNetworkImage(
                        //FadeInImage.memoryNetwork(
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(), //kTransparentImage,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        imageUrl: 'https:${p.apiFeaturedImage}',
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      p.name.toString(),
                      softWrap: true,
                      //maxLines: 2,
                      //overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(p.id.toString()),
                        isFavorited
                            ? const Padding(
                                padding: EdgeInsets.only(left: 28.0),
                                child: Icon(Icons.circle,
                                    size: 16, color: Colors.orangeAccent),
                              )
                            : const Text(''),
                      ],
                    ),
                    Text("Brand: ${p.brand?.toUpperCase()}"),
                    Text("PRICE: ${p.currency}${p.priceSign} $valor"),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: const Text('DETALHES'),
                            onPressed: () => _onClickDetails(p),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            child: const Text('SHARE'),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  _onClickDetails(Product p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetails(product: p)),
    );
  }
}
