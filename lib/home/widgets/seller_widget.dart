import 'package:big_root_market/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class SellerWidget extends StatefulWidget {
  const SellerWidget({super.key});

  @override
  State<SellerWidget> createState() => _SellerWidgetState();
}

class _SellerWidgetState extends State<SellerWidget> {
  TextEditingController searchTextEditingController = TextEditingController();
  final _db = FirebaseFirestore.instance;

  //검색 데이터 마지막 값을
  final _searchSubject = BehaviorSubject<String>();

  Future<List<Product>> fetchProducts() async {
    final resp = await _db.collection('products').orderBy('timeStamp').get();
    List<Product> items = [];
    //도큐먼트들을 가져옴.
    for (var doc in resp.docs) {
      final item = Product.fromJson(
        doc.data(),
      ); // map 형태의 doc.data() 를 Product 객체로 변환.

      // `doc.data()`에서 반환된 데이터는 `product` 객체에 사용되는 `docId` 값을 포함하지 않기 때문에,
      // `copyWith`를 사용하여 기존 `item` 객체에 `docId`를 추가한 새로운 객체를 생성.
      final realItem = item.copyWith(docId: doc.id);
      items.add(realItem);
    }
    return items;
  }

  // rxjs의 debounceTime 개념을 사용하여 검색시에 일정 타임을 줄거고
  // setstate가 현재는 검색어가 변경되면 바로 새로고침을 하는데 내가 보기엔 여기서 돌리는게 맞을거 같다.
  Stream<QuerySnapshot> streamProducts(String query) {
    if (query.isEmpty) {
      return _db.collection('products').orderBy('title').snapshots();
    }
    return _db.collection('products').orderBy('title').startAt([query]).endAt([
      "$query\uf8ff",
    ]).snapshots();
  }

  Future<Map<String, dynamic>> addCategory(String title) async {
    try {
      _db.collection('categories').add({'title': title});
      return {"result": true, "msg": "카테고리 추가 완료."};
    } catch (e) {
      return {"result": false, "msg": "카테고리 추가 실패."};
    }
  }

  Future<Map<String, dynamic>> addCategories(List<dynamic> titles) async {
    try {
      final categories = await _db.collection('categories').get();
      //여러 작업을 한번에 묶어서 처리할땐
      final batch = _db.batch();
      //중복 제거를 하고.
      for (var element in categories.docs) {
        if (titles.contains(element['title'])) {
          batch.delete(element.reference);
        }
      }
      //추가하기.
      for (final title in titles) {
        batch.set(_db.collection('categories').doc(), {'title': title});
      }
      await batch.commit();
      return {"result": true, "msg": "카테고리 일괄 등록 완료."};
    } catch (e) {
      debugPrint(e.toString());
      return {"result": false, "msg": "카테고리 일괄 등록 실패."};
    }
  }

  Future deleteProduct(Product product) async {
    try {
      // 선택 카테고리에 맞는 doc 가져온다.
      final categoryRef = _db
          .collection('categories')
          .doc(product.categoryDocId);

      // 해당 doc의 데이터중 field product 내부 value에 product.docId와 동일한 데이터를 삭제.
      await categoryRef.update({
        "products": FieldValue.arrayRemove([product.docId]),
      });
      //products 컬렉션 내부 product.docId와 동일한 document를 삭제.
      await _db.collection('products').doc(product.docId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchSubject.close();
    searchTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(
            controller: searchTextEditingController,
            leading: const Icon(Icons.search_outlined),
            hintText: '상품명 입력',
            onChanged: (value) => _searchSubject.add(value),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: OverflowBar(
              spacing: 12,
              alignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        List textEditingControllerList = [
                          [TextEditingController(), false],
                        ];
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog.adaptive(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...textEditingControllerList.asMap().entries.map((
                                    entry,
                                  ) {
                                    final TextEditingController textController =
                                        entry.value[0];
                                    final bool isPressed = entry.value[1];
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: textController,
                                            enabled: !isPressed,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (textController.text
                                                .trim()
                                                .isEmpty) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    '카테고리를 입력 해 주세요.',
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            setState(() {
                                              !isPressed
                                                  ? textEditingControllerList
                                                      .add([
                                                        TextEditingController(),
                                                        false,
                                                      ])
                                                  : textEditingControllerList
                                                      .removeAt(entry.key);

                                              entry.value[1] = !isPressed;
                                            });
                                          },
                                          icon:
                                              !isPressed
                                                  ? const Icon(
                                                    Icons.add_circle_outline,
                                                  )
                                                  : const Icon(
                                                    Icons.remove_circle_outline,
                                                  ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    final List<String> categorise = [
                                      '생수',
                                      '라면',
                                      '빵/쿠키',
                                      '과일',
                                      '유제품',
                                      '정육',
                                      '과자',
                                      '아이스크림',
                                    ];
                                    await addCategories(categorise);

                                    if (!context.mounted) return;
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Test 목록으로 등록'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final String lastTextFeildText =
                                        textEditingControllerList.last[0].text
                                            .trim();
                                    if (lastTextFeildText.isEmpty) {
                                      textEditingControllerList.removeLast();
                                    }
                                    final ListTextList =
                                        textEditingControllerList
                                            .map((list) => list[0].text.trim())
                                            .toList();

                                    final resultMap = await addCategories(
                                      ListTextList,
                                    );

                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(resultMap['msg'])),
                                    );

                                    if (resultMap['result']) {
                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: const Text('카테고리 일괄등록'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController titleTextEditingController =
                            TextEditingController();
                        return AlertDialog(
                          content: TextField(
                            controller: titleTextEditingController,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final title =
                                    titleTextEditingController.text.trim();
                                if (title.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('카테고리를 입력하세요.'),
                                    ),
                                  );
                                  return;
                                }
                                final result = await addCategory(title);
                                if (!context.mounted) return;
                                final resultType = result['result'] ?? false;
                                final resultMsg = result['msg'] ?? '';

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(resultMsg)),
                                );

                                if (resultType) {
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('카테고리 등록'),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              '상품목록',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              //switchMap 기존 스트림에서 새로운 값이 나오면, 이전 스트림을 취소하고 새로운 스트림만 유지.
              stream: _searchSubject
                  .debounceTime(const Duration(milliseconds: 300))
                  .switchMap((value) => streamProducts(value)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('오류발생 ${snapshot.error}');
                }

                final data = snapshot.data;
                if (data == null || data.docs.isEmpty) {
                  return const Text('상품이 없어요');
                }
                final items =
                    data.docs
                        .map(
                          (item) => Product.fromJson(
                            item.data() as Map<String, dynamic>,
                          ).copyWith(docId: item.id),
                        )
                        .toList();

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GestureDetector(
                      onTap: () {
                        debugPrint(item.docId);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        height: 120,
                        //color: Colors.orange,
                        child: Row(
                          children: [
                            Container(
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    item.imgUrl ??
                                        'https://picsum.photos/id/320/200/200',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.title ?? '제품명',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        PopupMenuButton(
                                          itemBuilder:
                                              (context) => [
                                                const PopupMenuItem(
                                                  child: Text('리뷰'),
                                                ),
                                                PopupMenuItem(
                                                  onTap: () async {
                                                    deleteProduct(item);
                                                  },
                                                  child: const Text('삭제'),
                                                ),
                                              ],
                                        ),
                                      ],
                                    ),
                                    Text('${item.price ?? '0'} 원'),
                                    Text(switch (item.isSale) {
                                      true => '할인 중',
                                      false => '할인 없음',
                                      _ => '에러 문의',
                                    }),
                                    Text('재고수량 : ${item.stock} 개'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
