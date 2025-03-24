import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final PageController _pageController = PageController();
  int _bannerIndex = 0;

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
                Container(color: Colors.red, height: 180),
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
                Container(height: 240, color: Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
