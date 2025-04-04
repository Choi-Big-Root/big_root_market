import 'package:big_root_market/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final String uid;
  const CartScreen({super.key, required this.uid});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _db = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamCart() {
    try {
      return _db
          .collection('cart')
          .where('uid', isEqualTo: widget.uid)
          .snapshots();
    } catch (e) {
      debugPrint('ERROR streamCart : ${e.toString()}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    return Scaffold(
      appBar: AppBar(title: const Text('장바구니')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: streamCart(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return const Text('오류 발생 문의 02-0000-0000');
                  }

                  if (snapshot.data == null) {
                    return const Text('장바구니가 비어있습니다.');
                  }

                  final docs = snapshot.data!.docs;

                  final List<Cart> cartList =
                      docs.map((e) {
                        return Cart.fromJson(e.data());
                      }).toList();

                  return ListView.separated(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      final product = Product.fromJson(
                        cartList[index].product!,
                      );
                      final cart = cartList[index];
                      final isSaleCal = (((product.saleRate ?? 0) / 100)
                          .toStringAsFixed(2));

                      final resultPrice =
                          (product.price! -
                                  (((product.price ?? 0) *
                                          (double.tryParse(isSaleCal) ?? 0.0)) *
                                      cart.count!))
                              .toInt();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(product.imgUrl!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(product.title ?? 'Dummy Text'),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                    Text('${resultPrice ?? 0} 원'),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),
                                        Text('${cart.count ?? 1}'),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, _) => const Divider(),
                  );
                },
              ),
            ),
            const Divider(),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '합계',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '1000000원',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 72,
                  color: Colors.red[100],
                  child: const Center(
                    child: Text(
                      '배달 주문',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
