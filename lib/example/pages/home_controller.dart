// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:playground/example/repositories/search_repository.dart';

import '../entities/filters_entity.dart';
import '../entities/product_entities.dart';

class HomeController {
  final SearchRepository repository;
  final priceRangeSelectedNotifier = ValueNotifier<RangeValues?>(null);
  RangeValues? get priceRangeSelected => priceRangeSelectedNotifier.value;
  set priceRangeSelected(RangeValues? value) =>
      priceRangeSelectedNotifier.value = value;

  final priceBoundRangeValueNotifier =
      ValueNotifier<RangeValues>(const RangeValues(0, 0));
  RangeValues get priceBoundRange => priceBoundRangeValueNotifier.value;
  set priceBoundRange(RangeValues value) =>
      priceBoundRangeValueNotifier.value = value;

  final pagingController =
      PagingController<int, ProductEntity>(firstPageKey: 0);
  final filterState = FilterState();

  bool filtered = true;

  HomeController({
    required this.repository,
  }) {
    filterState.filters.listen((_) {
      pagingController.refresh();
    });

    searcher.listen((page) {
      if (page.pageKey == 0) {
        pagingController.refresh();
      }
      pagingController.appendPage(page.items, page.nextPageKey);

      if (filtered) {
        filtered = false;
        priceRangeSelected = null;
        priceBoundRange = RangeValues(page.minPrice, page.maxPrice);
      }
    }).onError((error) => pagingController.error = error);
  }

  Stream<SearchEntity> get searcher => repository.init(filterState);

  search({required String term, int page = 0}) {
    final filters = FiltersEntity(term: term, page: page);
    repository.search(filters: filters);
  }

  filter() {
    pagingController.refresh();

    repository.filter(
        filters: FiltersEntity(
      priceStart: priceRangeSelected?.start,
      priceEnd: priceRangeSelected?.end,
    ));
  }

  Future<void> applyFilter() async {
    filtered = true;
    filter();
  }

  clearFilter() {
    filtered = true;
    pagingController.refresh();
    priceRangeSelected = null;
    filterState.clear();
    repository.initialFilter();
    filter();
  }

  FacetList buildFacetList(String attribute) {
    return repository.buildFacetList(
      attribute: attribute,
      filterState: filterState,
    );
  }

  void onChangePriceRange(RangeValues values) {
    filter();
    priceRangeSelected = RangeValues(
      double.parse(values.start.toStringAsFixed(2)),
      double.parse(values.end.toStringAsFixed(2)),
    );
  }
}
