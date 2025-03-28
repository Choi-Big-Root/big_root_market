import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SellerWidget extends StatefulWidget {
  const SellerWidget({super.key});

  @override
  State<SellerWidget> createState() => _SellerWidgetState();
}

class _SellerWidgetState extends State<SellerWidget> {
  final _db = FirebaseFirestore.instance;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SearchBar(),
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
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
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
                                  const Text(
                                    '제품 명',
                                    style: TextStyle(
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
                                          const PopupMenuItem(
                                            child: Text('삭제'),
                                          ),
                                        ],
                                  ),
                                ],
                              ),
                              const Text('100000원'),
                              const Text('할인중'),
                              const Text('재고수량'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
