import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:playground/example/datasource/search_datasource.dart';
import 'package:playground/example/models/filters_model.dart';

import '../entities/filters_entity.dart';
import '../entities/product_entities.dart';

class SearchRepository {
  final SearchDatasource datasource;

  SearchRepository(this.datasource);

  Stream<SearchEntity> init(FilterState filterState) {
    final result = datasource.init(filterState);

    return result.map((e) => e.toEntity());
  }

  search({required FiltersEntity filters}) =>
      datasource.search(filters: FiltersModel.fromEntity(filters));

  FacetList buildFacetList(
      {required String attribute, required FilterState filterState}) {
    return datasource.buildFacetList(
      attribute: attribute,
      filterState: filterState,
    );
  }

  void initialFilter() => datasource.initialFilter();

  void filter({
    required FiltersEntity filters,
  }) {
    datasource.filter(filters: FiltersModel.fromEntity(filters));
  }
}
