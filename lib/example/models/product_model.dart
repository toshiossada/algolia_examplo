import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

import '../entities/product_entities.dart';

class SearchModel {
  const SearchModel({
    required this.items,
    required this.pageKey,
    required this.nextPageKey,
    required this.nbHits,
  });

  final List<ProductModel> items;
  final int pageKey;
  final int? nextPageKey;
  final int nbHits;

  factory SearchModel.fromResponse(SearchResponse response) {
    final items = response.hits.map(ProductModel.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    final nbHits = response.nbHits;

    return SearchModel(
      items: items,
      pageKey: response.page,
      nextPageKey: nextPageKey,
      nbHits: nbHits,
    );
  }

  toEntity() {
    return SearchEntity(
        items: items.map<ProductEntity>((item) => item.toEntity()).toList(),
        pageKey: pageKey,
        nextPageKey: nextPageKey,
        nbHits: nbHits);
  }
}

class ProductModel {
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
  final List<TagModel> tags;
  final bool sobEncomenda;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.brand,
    required this.sellerName,
    required this.skuSeller,
    required this.sellerImage,
    required this.permalink,
    required this.discount,
    required this.precoDeTexto,
    required this.precoPorTexto,
    required this.tags,
    required this.sobEncomenda,
  });

  static ProductModel fromJson(Map<String, dynamic> json) {
    try {
      return ProductModel(
        id: json['_id'],
        name: json['name'],
        imageUrl: json['thumbnail'],
        brand: json['manufacturer'],
        sellerName: json['offer']['seller'],
        precoDeTexto: json['offer']?['originalPrice'] == null
            ? null
            : json['offer']['originalPrice'] * 1.0,
        precoPorTexto: json['offer']['price'] * 1.0,
        skuSeller: json['offer']['sellerSkuId'],
        sellerImage: '',
        permalink: '',
        discount: 0,
        tags: [
          const TagModel(
            name: 'Tag 1',
            color: 'FF0000',
            backgroundColor: 'FFFFFF',
          ),
          const TagModel(
            name: 'Tag 2',
            color: '00FF00',
            backgroundColor: '000000',
          ),
        ],
        sobEncomenda: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  toEntity() => ProductEntity(
        name: name,
        imageUrl: imageUrl,
        brand: brand,
        sellerName: sellerName,
        id: id,
        skuSeller: skuSeller,
        sellerImage: sellerImage,
        permalink: permalink,
        discount: discount,
        precoDeTexto: precoDeTexto,
        precoPorTexto: precoPorTexto,
        tags: tags.map<TagEntity>((e) => e.toEntity()).toList(),
        sobEncomenda: sobEncomenda,
      );
}

class TagModel {
  const TagModel({
    required this.name,
    required this.color,
    required this.backgroundColor,
  });

  final String name;
  final String color;
  final String backgroundColor;

  toEntity() => TagEntity(
        name: name,
        color: color,
        backgroundColor: backgroundColor,
      );
}
