import 'dart:math';
import 'dart:typed_data';

import 'package:big_root_market/home/camera_example.dart';
import 'package:big_root_market/model/category.dart';
import 'package:big_root_market/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Product _product;
  String _title = '';
  String _description = '';
  int _price = 0;
  int _stock = 0;
  bool _isSale = false;
  double _saleRate = 0.0;
  String _imgUrl = '';

  final db = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  Uint8List? imageData;
  XFile? image;
  Category? selectedCategory;

  List<Category> categorise = [];

  Future<List<Category>> _fecthCategories() async {
    final reps = await db.collection('categories').get();
    for (var doc in reps.docs) {
      debugPrint(doc.get('title'));
      debugPrint(doc.id);
      /*
      categorise.add(
        Category.fromJson({'title': doc.get('title'), 'docId': doc.id}),
      );
      */
      categorise.add(Category(title: doc.get('title'), docId: doc.id));

      debugPrint(categorise.toString());
    }
    return categorise;
  }

  /// 상품등록시 필요 데이터 정리 및 처리.
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _product = Product(
        docId: selectedCategory!.docId,
        title: _title,
        description: _description,
        price: _price,
        stock: _stock,
        isSale: _isSale,
        saleRate: _saleRate,
        imgUrl: _imgUrl,
        timeStamp: DateTime.now().millisecondsSinceEpoch,
      );

      debugPrint('저장된 상품 정보: $_product');
    } else {
      debugPrint('폼 검증 실패!');
    }
  }

  /// 이미지 압축
  Future<Uint8List> imageCompressList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(list, quality: 50);
    return result;
  }

  /// 상품 등록.
  Future addProduct() async {
    try {
      if (imageData != null && image != null) {
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image!.name}';
        // 이미지를 압축
        final compressedImage = await imageCompressList(imageData!);
        //이미지 업로드
        await supabase.storage
            .from('images')
            .uploadBinary(fileName, compressedImage);

        _imgUrl = supabase.storage.from('images').getPublicUrl(fileName);

        debugPrint(_imgUrl);

        _saveForm();

        // products 컬렉션에 _saveForm 함수를 통해 가공된 데이터 객체 _product 를 add
        final productRef = await db
            .collection('products')
            .add(_product.toJson());
        // categories 컬렉션에 현재 선택한 doc정보를 categoryRef 변수에 대입.
        final categoryRef = db
            .collection('categories')
            .doc(selectedCategory!.docId);
        // categoryRef[선택한 카테고리 doc 정보] 의 list products에 중복 제거하여 prodductRef.id 요소 추가.
        categoryRef.update({
          "products": FieldValue.arrayUnion([productRef.id]),
        });
      }
    } catch (e) {
      debugPrint('Product ADD ERROR : ${e.toString()}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상품 등록 실패 문의[02-0000-0000]')),
      );
    }
  }

  /// 상품 다중 등록 [Test용도 이며 추후 삭제.]
  Future addProducts() async {
    try {
      if (imageData != null && image != null) {
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image!.name}';
        // 이미지를 압축
        final compressedImage = await imageCompressList(imageData!);
        //이미지 업로드
        await supabase.storage
            .from('images')
            .uploadBinary(fileName, compressedImage);

        _imgUrl = supabase.storage.from('images').getPublicUrl(fileName);

        debugPrint(_imgUrl);

        for (var i = 1; i <= 10; i++) {
          _saveForm();
          _title = '$_title$i';
          _price = Random().nextInt(99000) + 1000;
          _isSale = true;
          double randomValue = Random().nextDouble() * (0.9 - 0.1) + 0.1;
          _saleRate = randomValue * 10;
          _stock = Random().nextInt(30) + 1;

          _product = Product(
            docId: selectedCategory!.docId,
            title: _title,
            description: _description,
            price: _price,
            stock: _stock,
            isSale: _isSale,
            saleRate: _saleRate,
            imgUrl: _imgUrl,
            timeStamp: DateTime.now().millisecondsSinceEpoch,
          );

          // products 컬렉션에 _saveForm 함수를 통해 가공된 데이터 객체 _product 를 add
          final productRef = await db
              .collection('products')
              .add(_product.toJson());
          // categories 컬렉션에 현재 선택한 doc정보를 categoryRef 변수에 대입.
          final categoryRef = db
              .collection('categories')
              .doc(selectedCategory!.docId);
          // categoryRef[선택한 카테고리 doc 정보] 의 list products에 중복 제거하여 prodductRef.id 요소 추가.
          categoryRef.update({
            "products": FieldValue.arrayUnion([productRef.id]),
          });
        }
      }
    } catch (e) {
      debugPrint('Product ADD ERROR : ${e.toString()}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상품 등록 실패 문의[02-0000-0000]')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fecthCategories()
        .then((_) {
          selectedCategory = categorise.first;
          setState(() {});
        })
        .catchError((e) {
          debugPrint(e.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품추가'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CameraExample()),
              );
            },
            icon: const Icon(Icons.camera),
          ),
          IconButton(
            onPressed: () {
              addProducts();
            },
            icon: const Icon(Icons.batch_prediction_outlined),
          ),
          IconButton(
            onPressed: () {
              addProduct();
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () async {
            final ImagePicker picker = ImagePicker();
            image = await picker.pickImage(source: ImageSource.gallery);
            debugPrint('${image?.name} , ${image?.path}');
            imageData = await image?.readAsBytes();

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child:
                        imageData == null
                            ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_outlined),
                                Text('제품(상품) 이미지 추가'),
                              ],
                            )
                            : Image.memory(imageData!, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '기본정보',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '상품명',
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '필수 입력사항 입니다.';
                          }
                          return null;
                        },
                        onSaved: (value) => _title = value!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '상품설명',
                        ),
                        maxLength: 254,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '필수 입력사항 입니다.';
                          }
                          return null;
                        },
                        onSaved: (value) => _description = value!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '가격(단가)',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '필수 입력사항 입니다.';
                          }
                          return null;
                        },
                        onSaved: (value) => _price = int.tryParse(value!) ?? 0,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '수량',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '필수 입력사항 입니다.';
                          }
                          return null;
                        },
                        onSaved: (value) => _stock = int.tryParse(value!) ?? 0,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile.adaptive(
                        value: _isSale,
                        onChanged: (value) {
                          setState(() {
                            _isSale = value;
                          });
                        },
                        title: const Text('할인여부'),
                      ),
                      if (_isSale)
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '할인율',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '할인율을 입력 해 주세요.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // value는 validator를 통해 null 체크를 해서 문제 없지만 tryparse를 통해 null값이 될 수 있다.
                            _saleRate = double.tryParse(value!) ?? 0.0;
                          },
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        '카테고리 선택',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      categorise.isNotEmpty
                          ? DropdownButton<Category>(
                            isExpanded: true,
                            value: selectedCategory,
                            items:
                                categorise
                                    .map(
                                      (e) => DropdownMenuItem<Category>(
                                        value: e,
                                        child: Text('${e.title}'),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                          )
                          : const Center(child: Text('로딩중....')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
