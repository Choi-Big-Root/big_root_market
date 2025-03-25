import 'package:flutter/material.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _isDisCount = false;

  String dropDownValue = 'test1'; //대기

  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController countTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품추가'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.batch_prediction_outlined),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_outlined)),
        ],
      ),
      body: SingleChildScrollView(
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.add_outlined), Text('제품(상품) 이미지 추가')],
                  ),
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
                    DropdownButton(
                      isExpanded: true,
                      value: dropDownValue,
                      items: const [
                        DropdownMenuItem(value: 'test1', child: Text('Test1')),
                        DropdownMenuItem(value: 'test2', child: Text('Test2')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          dropDownValue = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
