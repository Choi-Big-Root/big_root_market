import 'package:big_root_market/model/category.dart';
import 'package:big_root_market/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:go_router/go_router.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final PageController _pageController = PageController();
  int _bannerIndex = 0;
  final _db = FirebaseFirestore.instance;

  List<Category> categories = [];
  List<Product> salesProducts = [];

  /// 카테고리 목록 가져오기
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamCategories() {
    try {
      return _db.collection('categories').snapshots();
    } catch (e) {
      debugPrint('ERROR streamCategory : ${e.toString()}');
      return null;
    }
  }

  /// 할인 중인 상품 가져오기
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamSalesProducts() {
    try {
      return _db
          .collection('products')
          .where('isSale', isEqualTo: true)
          .orderBy('saleRate', descending: true)
          .snapshots();
    } catch (e) {
      debugPrint('ERROR streamSalesProducts : ${e.toString()}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 140,
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: PageView(
              controller: _pageController,
              children: [
                Image.asset('assets/fastcampus_logo.png'),
                Image.asset('assets/fastcampus_logo.png'),
                Image.asset('assets/fastcampus_logo.png'),
              ],
              onPageChanged: (index) {
                setState(() {
                  _bannerIndex = index;
                });
              },
            ),
          ),
          DotsIndicator(
            dotsCount: 3,
            position: _bannerIndex.toDouble(),
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '카테고리',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('더보기')),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: StreamBuilder(
                    stream: streamCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return const Text('오류가 발생했습니다. 문의 02-0000-0000');
                      }

                      if (snapshot.data == null) {
                        return const Text('카테고리가 존재하지 않습니다.');
                      }

                      final docs = snapshot.data;
                      categories.clear();
                      for (var doc in docs!.docs) {
                        categories.add(
                          Category(title: doc.get('title'), docId: doc.id),
                        );
                      }
                      //debugPrint(categories.toString());

                      return GridView.builder(
                        physics:
                            categories.length > 8
                                ? const AlwaysScrollableScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    'https://picsum.photos/id/${400 + index}/200/200',
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  categories[index].title ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.only(bottom: 16, top: 8, left: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '오늘의 특가',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('더보기')),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  //color: Colors.orange,
                  child: StreamBuilder(
                    stream: streamSalesProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return const Text('오류 발생 문의 02-0000-0000');
                      }

                      if (snapshot.data == null) {
                        return const Text('상품이 없습니다.');
                      }

                      final productDocs = snapshot.data!.docs;
                      salesProducts =
                          productDocs.map((doc) {
                            return Product.fromJson(
                              doc.data(),
                            ).copyWith(docId: doc.id);
                          }).toList();

                      return ListView.builder(
                        itemCount: salesProducts.length,
                        scrollDirection: Axis.horizontal, //이게 빠지면 문제가 발생.
                        itemBuilder: (context, index) {
                          final item = salesProducts[index];
                          final isSaleCal = (((item.saleRate ?? 0) / 100)
                              .toStringAsFixed(2));

                          final resultPrice =
                              item.price! -
                              ((item.price ?? 0) *
                                      (double.tryParse(isSaleCal) ?? 0.0))
                                  .toInt();
                          return GestureDetector(
                            onTap: () {
                              context.go('/product', extra: item);
                            },
                            child: Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        item.imgUrl ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.title ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${item.price} 원',
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                            235,
                                            221,
                                            255,
                                            1,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: const Color.fromRGBO(
                                              235,
                                              221,
                                              255,
                                              1,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          '-${item.saleRate!.toStringAsFixed(1)}%',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$resultPrice 원',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }
}
