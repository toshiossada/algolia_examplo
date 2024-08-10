import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:playground/example/entities/product_entities.dart';

import 'home_controller.dart';
import 'widgets/filter_widget.dart';

class MyHomePage extends StatefulWidget {
  final HomeController controller;
  const MyHomePage({super.key, required this.controller});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomeController get controller => widget.controller;
  final _searchTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();
  late final _categoryFacet = controller.buildFacetList('cat_lv'); //Categoria
  late final _sellerFacet =
      controller.buildFacetList('offer.seller'); //Vendido por

  late final _manufacturerFacet =
      controller.buildFacetList('manufacturer'); // Fabricante
  late final _brandFacet = controller.buildFacetList('brand'); // Marcas
  //Range de preços

  @override
  void initState() {
    super.initState();
    _searchTextController
        .addListener(() => controller.search(term: _searchTextController.text));

    controller.pagingController
        .addPageRequestListener((pageKey) => controller.search(
              term: _searchTextController.text,
              page: pageKey,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _mainScaffoldKey,
      appBar: AppBar(
        title: const Text('Algolia & Flutter'),
        actions: [
          IconButton(
              onPressed: () => _mainScaffoldKey.currentState?.openEndDrawer(),
              icon: const Icon(Icons.filter_list_sharp))
        ],
      ),
      endDrawer: Drawer(
        child: _filters(context),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchTextController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter a search term',
                    prefixIcon: Icon(Icons.search),
                  ),
                )),
            StreamBuilder<SearchEntity>(
              stream: controller.searcher,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${snapshot.data!.nbHits} hits'),
                );
              },
            ),
            Expanded(
              child: _hits(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _hits(BuildContext context) => PagedListView<int, ProductEntity>(
        pagingController: controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ProductEntity>(
          noItemsFoundIndicatorBuilder: (_) => const Center(
            child: Text('No results found'),
          ),
          firstPageProgressIndicatorBuilder: (_) => Center(
            child: Container(
              height: 100,
              width: 100,
              color: Colors.blue,
            ),
          ),
          newPageProgressIndicatorBuilder: (_) => Center(
            child: Container(
              height: 100,
              width: 100,
              color: Colors.red,
            ),
          ),
          itemBuilder: (_, item, __) => ListTile(
            leading: SizedBox(width: 50, child: Image.network(item.imageUrl)),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('id: ${item.id}'),
                Text('name: ${item.name}'),
                Text('brand: ${item.brand}'),
                Text('sellerName: ${item.sellerName}'),
                Text('precoDeTexto: ${item.precoDeTexto}'),
                Text('precoPorTexto: ${item.precoPorTexto}'),
                Text('skuSeller: ${item.skuSeller}'),
              ],
            ),
          ),
        ),
      );

  Widget _filters(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterWidet(
              facetsList: _categoryFacet,
              title: 'Categorias',
            ),
            FilterWidet(
              facetsList: _sellerFacet,
              title: 'Vendido por',
            ),
            ElevatedButton.icon(
              onPressed: () {
                controller.clearFilter();
              },
              label: const Icon(Icons.clear_all),
            )
          ],
        ),
      ));

  @override
  void dispose() {
    _searchTextController.dispose();
    controller.filterState.dispose();
    _sellerFacet.dispose();
    _categoryFacet.dispose();
    _brandFacet.dispose();
    _manufacturerFacet.dispose();
    super.dispose();
  }
}
