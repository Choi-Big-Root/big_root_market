import 'package:flutter/material.dart';

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
          IconButton(icon: const Icon(Icons.search_outlined), onPressed: () {}),
        ],
      ),
      body: IndexedStack(
        index: _menuindex,
        children: [
          Container(color: Colors.grey),
          Container(color: Colors.indigo),
        ],
      ),
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
