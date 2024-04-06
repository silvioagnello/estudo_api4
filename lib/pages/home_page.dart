import 'package:estudo_api4/pages/favorites_page.dart';
import 'package:estudo_api4/repositories/prefs.dart';
import 'package:estudo_api4/repositories/products_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/product_model.dart';
import '../widgets/products_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  TabController? _tabController;
  late int tabidx;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initTabs();
  }

  _initTabs() async {
    _tabController = TabController(vsync: this, length: 2, initialIndex: 1);
    if (!kIsWeb) {
      int tabidx = await Prefs.getInt('tabidx');
      setState(() {
        _tabController!.index = tabidx;
      });
      _tabController!.addListener(() {
        Prefs.setInt('tabidx', _tabController!.index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: TabBar(controller: _tabController, tabs: const [
            Tab(text: 'Favoritos'),
            Tab(text: 'Produtos'),
          ]),
        ),
        body: TabBarView(
            controller: _tabController,
            dragStartBehavior: DragStartBehavior.start,
            children: [
              ProductsListView(true), //FavoritesPage(),
              ProductsListView(),
            ]) //_body(),
        );
  }
}
