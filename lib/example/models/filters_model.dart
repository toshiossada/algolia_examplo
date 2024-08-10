import '../entities/filters_entity.dart';

class FiltersModel {
  final String? term;
  final String? orderBy;
  final String? typeShipping;
  final double? priceStart;
  final double? priceEnd;
  final String? slug;
  final int page;

  const FiltersModel({
    this.term,
    this.orderBy,
    this.typeShipping,
    this.priceStart,
    this.priceEnd,
    this.slug,
    this.page = 1,
  });

  factory FiltersModel.fromEntity(FiltersEntity model) => FiltersModel(
        term: model.term,
        orderBy: model.orderBy,
        typeShipping: model.typeShipping,
        priceStart: model.priceStart,
        priceEnd: model.priceEnd,
        slug: model.slug,
        page: model.page,
      );
}
