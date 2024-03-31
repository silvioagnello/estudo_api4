import 'package:estudo_api4/pages/home_page.dart';
import 'package:estudo_api4/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FavoritesRepository>(
        model: FavoritesRepository(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LISTA',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage(title: 'LISTAGEM'),
        ));
  }
}
