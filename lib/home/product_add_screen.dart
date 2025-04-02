import 'dart:io';
import 'dart:typed_data';

import 'package:big_root_market/home/camera_example.dart';
import 'package:big_root_market/model/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _isDisCount = false;

  final db = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  Uint8List? imageData;
  XFile? image;
  Category? selectedCategory;

  final TextEditingController titleTextEditingController =
      TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController countTextEditingController = TextEditingController();
  List<Category> categorise = [];

  Future<List<Category>> _fecthCategories() async {
    final reps = await db.collection('categories').get();
    for (var doc in reps.docs) {
      debugPrint(doc.get('title'));
      debugPrint(doc.id);
      categorise.add(
        Category.fromJson({'title': doc.get('title'), 'docId': doc.id}),
      );

      debugPrint(categorise.toString());
    }
    return categorise;
  }

  Future addProduct() async {
    if (imageData != null) {
      final file = File(image!.path);
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${image!.name}';
      await supabase.storage.from('images').upload(fileName, file);
      print(file);
      print(fileName);
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
            onPressed: () {},
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
                        controller: titleTextEditingController,
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
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionTextEditingController,
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
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: priceTextEditingController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '가격(단가)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '필수 입력사항 입니다.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: countTextEditingController,
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
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile.adaptive(
                        value: _isDisCount,
                        onChanged: (value) {
                          setState(() {
                            _isDisCount = value;
                          });
                        },
                        title: const Text('할인여부'),
                      ),
                      if (_isDisCount)
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '할인율',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return null;
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
