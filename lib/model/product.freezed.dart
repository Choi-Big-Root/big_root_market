// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String? get docId; String? get title; String? get description; int? get price; int? get stock; bool? get isSale; double? get saleRate; String? get imgUrl; int? get timeStamp; String? get categoryDocId;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.docId, docId) || other.docId == docId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.isSale, isSale) || other.isSale == isSale)&&(identical(other.saleRate, saleRate) || other.saleRate == saleRate)&&(identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl)&&(identical(other.timeStamp, timeStamp) || other.timeStamp == timeStamp)&&(identical(other.categoryDocId, categoryDocId) || other.categoryDocId == categoryDocId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,docId,title,description,price,stock,isSale,saleRate,imgUrl,timeStamp,categoryDocId);

@override
String toString() {
  return 'Product(docId: $docId, title: $title, description: $description, price: $price, stock: $stock, isSale: $isSale, saleRate: $saleRate, imgUrl: $imgUrl, timeStamp: $timeStamp, categoryDocId: $categoryDocId)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String? docId, String? title, String? description, int? price, int? stock, bool? isSale, double? saleRate, String? imgUrl, int? timeStamp, String? categoryDocId
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? docId = freezed,Object? title = freezed,Object? description = freezed,Object? price = freezed,Object? stock = freezed,Object? isSale = freezed,Object? saleRate = freezed,Object? imgUrl = freezed,Object? timeStamp = freezed,Object? categoryDocId = freezed,}) {
  return _then(_self.copyWith(
docId: freezed == docId ? _self.docId : docId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int?,isSale: freezed == isSale ? _self.isSale : isSale // ignore: cast_nullable_to_non_nullable
as bool?,saleRate: freezed == saleRate ? _self.saleRate : saleRate // ignore: cast_nullable_to_non_nullable
as double?,imgUrl: freezed == imgUrl ? _self.imgUrl : imgUrl // ignore: cast_nullable_to_non_nullable
as String?,timeStamp: freezed == timeStamp ? _self.timeStamp : timeStamp // ignore: cast_nullable_to_non_nullable
as int?,categoryDocId: freezed == categoryDocId ? _self.categoryDocId : categoryDocId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Product implements Product {
   _Product({this.docId, this.title, this.description, this.price, this.stock, this.isSale, this.saleRate, this.imgUrl, this.timeStamp, this.categoryDocId});
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String? docId;
@override final  String? title;
@override final  String? description;
@override final  int? price;
@override final  int? stock;
@override final  bool? isSale;
@override final  double? saleRate;
@override final  String? imgUrl;
@override final  int? timeStamp;
@override final  String? categoryDocId;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.docId, docId) || other.docId == docId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.isSale, isSale) || other.isSale == isSale)&&(identical(other.saleRate, saleRate) || other.saleRate == saleRate)&&(identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl)&&(identical(other.timeStamp, timeStamp) || other.timeStamp == timeStamp)&&(identical(other.categoryDocId, categoryDocId) || other.categoryDocId == categoryDocId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,docId,title,description,price,stock,isSale,saleRate,imgUrl,timeStamp,categoryDocId);

@override
String toString() {
  return 'Product(docId: $docId, title: $title, description: $description, price: $price, stock: $stock, isSale: $isSale, saleRate: $saleRate, imgUrl: $imgUrl, timeStamp: $timeStamp, categoryDocId: $categoryDocId)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String? docId, String? title, String? description, int? price, int? stock, bool? isSale, double? saleRate, String? imgUrl, int? timeStamp, String? categoryDocId
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? docId = freezed,Object? title = freezed,Object? description = freezed,Object? price = freezed,Object? stock = freezed,Object? isSale = freezed,Object? saleRate = freezed,Object? imgUrl = freezed,Object? timeStamp = freezed,Object? categoryDocId = freezed,}) {
  return _then(_Product(
docId: freezed == docId ? _self.docId : docId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int?,isSale: freezed == isSale ? _self.isSale : isSale // ignore: cast_nullable_to_non_nullable
as bool?,saleRate: freezed == saleRate ? _self.saleRate : saleRate // ignore: cast_nullable_to_non_nullable
as double?,imgUrl: freezed == imgUrl ? _self.imgUrl : imgUrl // ignore: cast_nullable_to_non_nullable
as String?,timeStamp: freezed == timeStamp ? _self.timeStamp : timeStamp // ignore: cast_nullable_to_non_nullable
as int?,categoryDocId: freezed == categoryDocId ? _self.categoryDocId : categoryDocId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Cart {

 String? get cartDocId; String? get uid; String? get email; int? get timeStamp; int? get count; Product? get product;
/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartCopyWith<Cart> get copyWith => _$CartCopyWithImpl<Cart>(this as Cart, _$identity);

  /// Serializes this Cart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cart&&(identical(other.cartDocId, cartDocId) || other.cartDocId == cartDocId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.timeStamp, timeStamp) || other.timeStamp == timeStamp)&&(identical(other.count, count) || other.count == count)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cartDocId,uid,email,timeStamp,count,product);

@override
String toString() {
  return 'Cart(cartDocId: $cartDocId, uid: $uid, email: $email, timeStamp: $timeStamp, count: $count, product: $product)';
}


}

/// @nodoc
abstract mixin class $CartCopyWith<$Res>  {
  factory $CartCopyWith(Cart value, $Res Function(Cart) _then) = _$CartCopyWithImpl;
@useResult
$Res call({
 String? cartDocId, String? uid, String? email, int? timeStamp, int? count, Product? product
});


$ProductCopyWith<$Res>? get product;

}
/// @nodoc
class _$CartCopyWithImpl<$Res>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._self, this._then);

  final Cart _self;
  final $Res Function(Cart) _then;

/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cartDocId = freezed,Object? uid = freezed,Object? email = freezed,Object? timeStamp = freezed,Object? count = freezed,Object? product = freezed,}) {
  return _then(_self.copyWith(
cartDocId: freezed == cartDocId ? _self.cartDocId : cartDocId // ignore: cast_nullable_to_non_nullable
as String?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,timeStamp: freezed == timeStamp ? _self.timeStamp : timeStamp // ignore: cast_nullable_to_non_nullable
as int?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product?,
  ));
}
/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Cart implements Cart {
   _Cart({this.cartDocId, this.uid, this.email, this.timeStamp, this.count, this.product});
  factory _Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

@override final  String? cartDocId;
@override final  String? uid;
@override final  String? email;
@override final  int? timeStamp;
@override final  int? count;
@override final  Product? product;

/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartCopyWith<_Cart> get copyWith => __$CartCopyWithImpl<_Cart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cart&&(identical(other.cartDocId, cartDocId) || other.cartDocId == cartDocId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.timeStamp, timeStamp) || other.timeStamp == timeStamp)&&(identical(other.count, count) || other.count == count)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cartDocId,uid,email,timeStamp,count,product);

@override
String toString() {
  return 'Cart(cartDocId: $cartDocId, uid: $uid, email: $email, timeStamp: $timeStamp, count: $count, product: $product)';
}


}

/// @nodoc
abstract mixin class _$CartCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$CartCopyWith(_Cart value, $Res Function(_Cart) _then) = __$CartCopyWithImpl;
@override @useResult
$Res call({
 String? cartDocId, String? uid, String? email, int? timeStamp, int? count, Product? product
});


@override $ProductCopyWith<$Res>? get product;

}
/// @nodoc
class __$CartCopyWithImpl<$Res>
    implements _$CartCopyWith<$Res> {
  __$CartCopyWithImpl(this._self, this._then);

  final _Cart _self;
  final $Res Function(_Cart) _then;

/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cartDocId = freezed,Object? uid = freezed,Object? email = freezed,Object? timeStamp = freezed,Object? count = freezed,Object? product = freezed,}) {
  return _then(_Cart(
cartDocId: freezed == cartDocId ? _self.cartDocId : cartDocId // ignore: cast_nullable_to_non_nullable
as String?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,timeStamp: freezed == timeStamp ? _self.timeStamp : timeStamp // ignore: cast_nullable_to_non_nullable
as int?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product?,
  ));
}

/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

// dart format on
