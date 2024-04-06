import 'package:cached_network_image/cached_network_image.dart';
import 'package:estudo_api4/models/favorited_model.dart';
import 'package:estudo_api4/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../models/product_model.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with AutomaticKeepAliveClientMixin<FavoritesPage> {
  List<Product> products = [];

  final model = FavoritedModel();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
    model.getFavorited();
    //return products = faveBloc.faveProducts;
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   favoritedBloc.dispose();
  // } // void getProducts() async {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Observer(
      builder: (context) {
        //model.getFavorited();
        products = model.faveProducts;

        if (products.isEmpty || products == null) {
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
        if (products.isNotEmpty) {
          return _listView(products);
        }
        if (model.error != '') {
          return Center(
            child: Text(model.error),
          );
        }
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
      },
    );
  }

  _listView(table) {
    var isFavorited = false;
    print('1234 ${table.length}');
    return Container(
      padding: const EdgeInsets.all(18),
      child: ListView.builder(
        itemCount: table.length,
        itemBuilder: (context, index) {
          String valor = '0';
          Product p = table[index];
          String? val = p.price ?? '0.0';
          valor = double.parse(val).toStringAsFixed(2);

          // var isFavorited = products.firstWhereOrNull(
          //         (k) => k.id.toString() == p.id.toString()) !=
          //     null
          //     ? true
          //     : false;

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
                        const CircularProgressIndicator(),
                    //kTransparentImage,
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
                            // _onClickDetails(p);
                            //
                            // getFavoritos();
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
        //getFavoritos();
      }),
    );
  }
}
