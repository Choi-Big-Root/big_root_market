// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  docId: json['docId'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toInt(),
  isSale: json['isSale'] as bool?,
  stock: (json['stock'] as num?)?.toInt(),
  saleRate: (json['saleRate'] as num?)?.toDouble(),
  imgUrl: json['imgUrl'] as String?,
  timeStamp: (json['timeStamp'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'docId': instance.docId,
  'title': instance.title,
  'description': instance.description,
  'price': instance.price,
  'isSale': instance.isSale,
  'stock': instance.stock,
  'saleRate': instance.saleRate,
  'imgUrl': instance.imgUrl,
  'timeStamp': instance.timeStamp,
};

_Cart _$CartFromJson(Map<String, dynamic> json) => _Cart(
  cartDocId: json['cartDocId'] as String?,
  uid: json['uid'] as String?,
  email: json['email'] as String?,
  timeStamp: (json['timeStamp'] as num?)?.toInt(),
  count: (json['count'] as num?)?.toInt(),
  product:
      json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CartToJson(_Cart instance) => <String, dynamic>{
  'cartDocId': instance.cartDocId,
  'uid': instance.uid,
  'email': instance.email,
  'timeStamp': instance.timeStamp,
  'count': instance.count,
  'product': instance.product,
};
