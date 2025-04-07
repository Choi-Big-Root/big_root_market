import 'package:big_root_market/home/product_add_screen.dart';
import 'package:big_root_market/home/widgets/home_widget.dart';
import 'package:big_root_market/home/widgets/seller_widget.dart';
import 'package:big_root_market/login/provider/login_provider.dart';
import 'package:big_root_market/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _menuindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('BigRoot마트'),
        actions: [
          IconButton(icon: const Icon(Icons.logout_outlined), onPressed: () {}),
          if (_menuindex == 0)
            IconButton(
              icon: const Icon(Icons.search_outlined),
              onPressed: () {},
            ),
        ],
      ),
      body: IndexedStack(
        index: _menuindex,
        children: const [HomeWidget(), SellerWidget()],
      ),
      floatingActionButton:
      // _menuindex == 0
      //     ? FloatingActionButton(
      //       onPressed: () {},
      //       child: const Icon(Icons.shopping_cart_outlined),
      //     )
      //     : _menuindex == 1
      //     ? FloatingActionButton(
      //       onPressed: () {},
      //       child: const Icon(Icons.add),
      //     )
      //     : Container(),
      switch (_menuindex) {
        0 => Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final user = ref.watch(userProvider);
            return FloatingActionButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const CartScreen(uid: ''),
                //   ),
                //
                // );
                context.go('/cart/${user!.user!.uid}');
              },
              child: const Icon(Icons.shopping_cart_outlined),
            );
          },
        ),
        1 => FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProductAddScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
        _ => Container(),
      },

      bottomNavigationBar: NavigationBar(
        selectedIndex: _menuindex,
        onDestinationSelected: (index) {
          setState(() {
            _menuindex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            label: '사장님(판매자)',
          ),
        ],
      ),
    );
  }
}
