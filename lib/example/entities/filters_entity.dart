class FiltersEntity {
  final String? term;
  final String? orderBy;
  final String? typeShipping;
  final double? priceStart;
  final double? priceEnd;
  final String? slug;
  final int page;

  const FiltersEntity({
    this.term,
    this.orderBy,
    this.typeShipping,
    this.priceStart,
    this.priceEnd,
    this.slug,
    this.page = 1,
  });
}
