import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product_model.dart';
import '../pages/product_details.dart';
import '../repositories/favorites_repository.dart';
import '../repositories/products_bloc.dart';
import '../repositories/products_repository.dart';

class ProductsListView extends StatelessWidget {
  List<Product> products;

  ProductsListView(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        String valor = '0';
        Product p = products[index];
        String? val = p.price ?? '0.0';
        valor = double.parse(val).toStringAsFixed(2);
        //var isFavorited = model.getFav(p);
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
                  // isFavorited
                  //     ? const Padding(
                  //         padding: EdgeInsets.only(left: 28.0),
                  //         child: Icon(Icons.circle,
                  //             size: 16, color: Colors.orangeAccent),
                  //       )
                  //     : const Text(''),
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
                      onPressed: () => _onClickDetails(context, p),
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
  }

  _onClickDetails(context, Product p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetails(product: p)),
    );
  }
}
