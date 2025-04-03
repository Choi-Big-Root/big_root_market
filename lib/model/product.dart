import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
sealed class Product with _$Product {
  factory Product({
    String? docId,
    String? title,
    String? description,
    int? price,
    int? stock,
    bool? isSale,
    double? saleRate,
    String? imgUrl,
    int? timeStamp,
  }) = _Product;
  //여기까지가 기본적인 freezed 이고.
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
sealed class Cart with _$Cart {
  factory Cart({
    String? cartDocId,
    String? uid,
    String? email,
    int? timeStamp,
    int? count,
    Product? product,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}
