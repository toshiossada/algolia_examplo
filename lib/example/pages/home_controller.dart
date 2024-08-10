// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:playground/example/repositories/search_repository.dart';

import '../entities/filters_entity.dart';
import '../entities/product_entities.dart';

class HomeController {
  final SearchRepository repository;
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
    }).onError((error) => pagingController.error = error);
  }
  final pagingController =
      PagingController<int, ProductEntity>(firstPageKey: 0);
  final filterState = FilterState();

  Stream<SearchEntity> get searcher => repository.init(filterState);

  search({required String term, int page = 0}) {
    final filters = FiltersEntity(term: term, page: page);
    repository.search(filters: filters);
  }

  filter() {
    pagingController.refresh();

    repository.filter(
        filters: const FiltersEntity(
      priceStart: 10,
      priceEnd: 50,
    ));
  }

  clearFilter() {
    pagingController.refresh();
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
}
