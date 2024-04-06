import 'package:estudo_api4/pages/home_page.dart';
import 'package:estudo_api4/repositories/favorites_bloc.dart';
import 'package:estudo_api4/repositories/products_favorited_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FavoritesBloc>(
            create: (_) => FavoritesBloc(),
            dispose: (context, bloc1) => bloc1.dispose()),
        ChangeNotifierProvider<Favoritedbloc>(
          create: (_) => Favoritedbloc(),
          //dispose: (context, bloc) => bloc.dispose(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LISTA',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(title: 'LISTAGEM'),
      ),
    );
  }
}
