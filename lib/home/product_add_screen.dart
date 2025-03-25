import 'package:flutter/material.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            decoration: const BoxDecoration(color: Colors.red),
                            child: const Text(
                              '할인중',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return <PopupMenuEntry>[
                                  const PopupMenuItem(
                                    value: 'test',
                                    child: Text('리뷰작성'),
                                  ),
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
                            Icon(Icons.star, color: Colors.orange),
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
