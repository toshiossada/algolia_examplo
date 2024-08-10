class SearchEntity {
  const SearchEntity(
      {required this.items,
      required this.pageKey,
      required this.nextPageKey,
      required this.nbHits});

  final List<ProductEntity> items;
  final int pageKey;
  final int? nextPageKey;
  final int nbHits;
}

class ProductEntity {
  final String id;
  final String name;
  final String sellerName;
  final String? brand;
  final String imageUrl;
  final String skuSeller;
  final String sellerImage;
  final String permalink;
  final int discount;
  final double? precoDeTexto;
  final double precoPorTexto;
  final List<TagEntity> tags;
  final bool sobEncomenda;

  ProductEntity({
    required this.name,
    required this.id,
    required this.sellerName,
    required this.brand,
    required this.imageUrl,
    required this.skuSeller,
    required this.sellerImage,
    required this.permalink,
    required this.discount,
    required this.precoDeTexto,
    required this.precoPorTexto,
    required this.tags,
    required this.sobEncomenda,
  });
}

class TagEntity {
  const TagEntity({
    required this.name,
    required this.color,
    required this.backgroundColor,
  });

  final String name;
  final String color;
  final String backgroundColor;
}
