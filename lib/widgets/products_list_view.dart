import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:estudo_api4/repositories/products_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../pages/product_details.dart';
import '../repositories/products_favorited_bloc.dart';
import '../repositories/products_bloc.dart';

class ProductsListView extends StatefulWidget {
  const ProductsListView([List<Product>? produtos]);

  @override
  State<ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView>
    with AutomaticKeepAliveClientMixin<ProductsListView> {
  List<Product> products = [];
  List<Product>? productFaves = [];
  //List<Favorite>? favoritos = [];

  //ProductsRepository productsRepository = ProductsRepository();

  // ProductsBloc productsBloc = ProductsBloc();
  //final StreamController _streamController = StreamController<List<Product>>();
  //FavoritesRepository favoritesRepository = FavoritesRepository();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getProducts();
    getFavoritos2();
  }

  Future<List<Product>> getProducts() async {
    // ProductsRepository.getProductsApi(),
    // try {
    products = await ProductsRepository.getProductsApi();
    return products;
    // } on Exception catch (e) {
    //   return products;
    // }
  }

  void getFavoritos2() async {
    Favoritedbloc faveBloc = Provider.of<Favoritedbloc>(context, listen: false);
    faveBloc.getFavorited();
    productFaves = faveBloc.faveProducts;
    print('Faves $productFaves');
  }

  @override
  void dispose() {
    super.dispose();
    //productsBloc.dispose();
  } // void getProducts() async {

  @override
  Widget build(context) {
    super.build(context);

    return FutureBuilder(
      future: getProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Não foi possível conexão com os dados'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: const Icon(Icons.refresh, size: 50),
                      onPressed: getProducts),
                )
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          List<Product>? produtos = snapshot.data;
          if (products.isNotEmpty) {
            return _listView(products);
          }
        }

        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.green));
        }
        // print(snapshot.connectionState);
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sem dados'),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                    icon: Icon(Icons.refresh, size: 50), onPressed: null),
              ),
            ],
          ),
        );
      },
    );
  }

  _listView(table) {
    var isFavorited = false;

    Favoritedbloc faveBloc = Provider.of<Favoritedbloc>(context);
    productFaves = faveBloc.faveProducts;

    return Container(
      padding: const EdgeInsets.all(18),
      child: ListView.builder(
        itemCount: table.length,
        itemBuilder: (context, index) {
          String valor = '0';
          Product p = table[index];
          String? val = p.price ?? '0.0';
          valor = double.parse(val).toStringAsFixed(2);

          var isFavorited = productFaves?.firstWhereOrNull(
                      (k) => k.id.toString() == p.id.toString()) !=
                  null
              ? true
              : false;

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
                          onPressed: () {
                            _onClickDetails(p);

                            getFavoritos2();
                          }),
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
      ),
      //),
    );
  }
  //);

  _onClickDetails(Product p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ProductDetails(product: p);
        getFavoritos2();
      }),
    );
  }
}
