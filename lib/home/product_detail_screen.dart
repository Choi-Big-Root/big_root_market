import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BigRoot 제품 상세')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 320,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(color: Colors.orange),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: Colors.red),
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
                            const Text(
                              'BigRoot 플러터',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return <PopupMenuItem>[
                                  const PopupMenuItem(child: Text('리뷰작성')),
                                ];
                              },
                            ),
                          ],
                        ),
                        const Text('제품 상세 정보'),
                        const Text('상세상세'),
                        const Row(
                          children: [
                            Text(
                              '100000원',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              //Icons.star_border_outlined,
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Text('4.5'),
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
        ],
      ),
    );
  }
}
