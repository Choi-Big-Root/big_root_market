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
          .orderBy("timeStamp")
          .snapshots();
    } catch (e) {
      debugPrint('ERROR streamCart : ${e.toString()}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        return Cart.fromJson({...e.data(), "cartDocId": e.id});
                      }).toList();

                  //print(cartList);
                  return ListView.separated(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      final product = Product.fromJson(
                        cartList[index].product!,
                      );
                      final cart = cartList[index];
                      final resultPrice =
                          (product.isSale ?? false)
                              ? ((product.price ?? 0) -
                                          product.saleRate! /
                                              100 *
                                              product.price!)
                                      .toInt() *
                                  cart.count!
                              : (product.price ?? 0).toInt() * cart.count!;

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
                                          onPressed: () {
                                            final doc = _db
                                                .collection('cart')
                                                .doc(cart.cartDocId);
                                            doc
                                                .delete()
                                                .then((_) {
                                                  if (!context.mounted) return;
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        '정상적으로 제거 되었습니다.',
                                                      ),
                                                    ),
                                                  );
                                                })
                                                .catchError((e) {
                                                  if (!context.mounted) return;
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return const AlertDialog.adaptive(
                                                        content: Text('삭제 오류'),
                                                      );
                                                    },
                                                  );
                                                });
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                    Text('$resultPrice 원'),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            if (cart.count! <= 1 ||
                                                cart.count == null) {
                                              return;
                                            }

                                            await _db
                                                .collection('cart')
                                                .doc("${cart.cartDocId}")
                                                .update({
                                                  "count": cart.count! - 1,
                                                });
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),
                                        Text('${cart.count ?? 1}'),
                                        IconButton(
                                          onPressed: () async {
                                            await _db
                                                .collection('cart')
                                                .doc("${cart.cartDocId}")
                                                .update({
                                                  "count": cart.count! + 1,
                                                });
                                          },
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '합계',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder(
                        stream: streamCart(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('오류 발생 문의하세요. 02-0000-0000');
                          }
                          if (!snapshot.hasData) {
                            return const Text('장바구니가 비어 있습니다.');
                          }

                          final List<Cart> cartItems =
                              snapshot.data!.docs.map((e) {
                                final foo = Cart.fromJson(e.data());
                                return foo.copyWith(cartDocId: e.id);
                              }).toList();
                          var totalPrice = 0;
                          for (var item in cartItems) {
                            final product = Product.fromJson(item.product!);

                            if (product.isSale ?? false) {
                              totalPrice +=
                                  ((product.price ?? 0) -
                                          (product.saleRate! /
                                              100 *
                                              (product.price ?? 0)))
                                      .toInt() *
                                  (item.count ?? 1);
                            } else {
                              totalPrice +=
                                  (product.price ?? 0).toInt() *
                                  (item.count ?? 1);
                            }
                          }

                          return Text(
                            '$totalPrice원',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
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
