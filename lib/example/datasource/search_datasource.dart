import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:playground/example/models/product_model.dart';

import '../models/filters_model.dart';

class SearchDatasource {
  final HitsSearcher searcher;
  late FilterState filterState;
  SearchDatasource({required this.searcher});

  _getSellersCode() {
    return '13637,15273,15412,13657,15235,15681,15697,11107,4430,15389,15436,15442,15502,15052,15242,15410,15522,14747,14750,15465,1018,10931,13912,15061,13501,14909,170,275,1000,15201';
  }

  List<FilterFacet> _formatSellers() => _getSellersCode()
      .split(',')
      .map<FilterFacet>(
          (e) => Filter.facet('offer.warehouses.metadata.sellerId', e.trim()))
      .toList();

  Stream<SearchModel> init(FilterState filterState) {
    this.filterState = filterState;
    initialFilter();

    searcher.connectFilterState(this.filterState);

    return searcher.responses.map(SearchModel.fromResponse);
  }

  void initialFilter() {
    final sellers = _formatSellers();

    filterState.add(const FilterGroupID('available_stock'),
        [Filter.facet('available_stock', 'true')]);
    filterState.add(
      const FilterGroupID(
          'offer.warehouses.metadata.sellerId', FilterOperator.or),
      sellers,
    );
  }

  search({
    required FiltersModel filters,
  }) {
    searcher.applyState(
      (state) => state.copyWith(
        // indexName: '', // Ordenaçao
        query: filters.term,
        page: filters.page,
      ),
    );
  }

  filter({
    required FiltersModel filters,
  }) {
    const offer = FilterGroupID('offer.price', FilterOperator.and);

    filterState.clear([offer]);

    filterState.add(offer, [
      Filter.comparison('offer.price', NumericOperator.greaterOrEquals,
          filters.priceStart ?? double.infinity),
      Filter.comparison(
          'offer.price', NumericOperator.lessOrEquals, filters.priceEnd ?? 0)
    ]);
  }

  FacetList buildFacetList({
    required String attribute,
    required FilterState filterState,
  }) {
    //offer.finalPrice,¹ dep_lv, cat_lv e offer.seller

    return searcher.buildFacetList(
      filterState: filterState,
      attribute: attribute,
    );
  }
}
