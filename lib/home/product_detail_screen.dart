import 'package:big_root_market/main.dart';
import 'package:big_root_market/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _db = FirebaseFirestore.instance;

  Future addCart(Product selectProduct) async {
    try {
      final cart =
          await _db
              .collection('cart')
              .where('uid', isEqualTo: userCredential.user?.uid ?? '')
              .where('product.docId', isEqualTo: selectProduct.docId)
              .get();

      if (!mounted) return;
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('test')));

      if (cart.docs.isNotEmpty) {
        showDialog(
          context: context,
          builder:
              (context) =>
                  const AlertDialog(content: Text('이미 장바구니에 등록되어 있는 상품 입니다.')),
        );
        return;
      }
      await _db
          .collection('cart')
          .add(
            Cart(
              uid: userCredential.user!.uid,
              email: userCredential.user!.email,
              timeStamp: DateTime.now().millisecondsSinceEpoch,
              count: 1,
              product: selectProduct.toJson(),
            ).toJson(),
          );

      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (context) => const AlertDialog(content: Text('장바구니에 등록되었습니다.')),
      );
    } catch (e) {
      debugPrint('ERROR addCart : ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(title: Text(product.title ?? 'BigRoot 제품 상세')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 320,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        image: DecorationImage(
                          image: NetworkImage(product.imgUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            switch (product.isSale) {
                              true => Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                                child: const Text(
                                  '할인중',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              _ => Container(),
                            },
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.title ?? 'BigRoot 플러터',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) {
                                  return <PopupMenuItem>[
                                    PopupMenuItem(
                                      child: const Text('리뷰작성'),
                                      onTap: () {
                                        int reviewScore = 0;
                                        TextEditingController
                                        reviewTextEditingController =
                                            TextEditingController();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                  title: const Text('리뷰작성'),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            reviewTextEditingController,
                                                      ),
                                                      Row(
                                                        children: List.generate(
                                                          5,
                                                          (
                                                            int index,
                                                          ) => IconButton(
                                                            onPressed: () {
                                                              setState(
                                                                () =>
                                                                    reviewScore =
                                                                        index,
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons.star,
                                                              color:
                                                                  index <=
                                                                          reviewScore
                                                                      ? Colors
                                                                          .orange
                                                                      : Colors
                                                                          .grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                      child: const Text('취소'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {},
                                                      child: const Text('확인'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                          const Text('제품 상세 정보'),
                          Text(product.description ?? '상세'),
                          Row(
                            children: [
                              Text(
                                '${product.price ?? 100000} 원',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                //Icons.star_border_outlined,
                                Icons.star,
                                color: Colors.orange,
                              ),
                              const Text('4.5'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(tabs: [Tab(text: '제품 상세'), Tab(text: '리뷰')]),
                          SizedBox(
                            height: 500,
                            child: TabBarView(
                              children: [Text('제품 상세'), Text('리뷰')],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                addCart(widget.product);
              },
              child: Container(
                height: 72,
                color: Colors.red[100],
                child: const Center(
                  child: Text(
                    '장바구니',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
