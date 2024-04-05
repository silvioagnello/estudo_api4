import 'dart:async';

import 'package:estudo_api4/repositories/products_favorited_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../repositories/favorites_repository.dart';
import '../repositories/products_bloc.dart';
import '../repositories/products_repository.dart';
import '../widgets/products_list_view.dart';
//import '../widgets/products_list_view2.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with AutomaticKeepAliveClientMixin<FavoritesPage> {
  List<Product>? products = [];
  // ProductsBloc productsBloc = ProductsBloc();
  Favoritedbloc favoritedBloc = Favoritedbloc();
  //final StreamController _streamController = StreamController<List<Product>>();
  // FavoritesRepository favoritesRepository = FavoritesRepository();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getFavoritos();
  }

  void getFavoritos() async {
    favoritedBloc.getFavorited();
  }

  @override
  void dispose() {
    super.dispose();
    favoritedBloc.dispose();
  } // void getProducts() async {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //Favoritesbloc favoritosBloc = Provider.of<Favoritesbloc>(context);
    // Future<List<Product>> favoritos = ProductsRepository.getProductsApi();
    // print('total ${products?.length}');

    return FutureBuilder(
      future: null,
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
          //List<Product>? produtos = snapshot.data;
          if (products!.isNotEmpty) {
            return ProductsListView(products);
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
}
