import 'package:big_root_market/firebase_options.dart';
import 'package:big_root_market/home/cart_screen.dart';
import 'package:big_root_market/home/home_screen.dart';
import 'package:big_root_market/home/product_add_screen.dart';
import 'package:big_root_market/home/product_detail_screen.dart';
import 'package:big_root_market/login/login_screen.dart';
import 'package:big_root_market/login/sign_up_screen.dart';
import 'package:big_root_market/model/product.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  cameras = await availableCameras();

  //firebase Storage 가 무료버전이 없어 대체가능한 supabase를 사용.
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    try {
      //구글 로그인은 localemulator에서 동작하지 않아 임시로 주석처리.
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      //final supabase = Supabase.instance.client;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  runApp(ProviderScope(child: BigRootMarketApp()));
}

class BigRootMarketApp extends StatelessWidget {
  BigRootMarketApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'cart/:uid',
            builder:
                (context, state) =>
                    CartScreen(uid: state.pathParameters['uid'] ?? ''),
          ),
          GoRoute(
            path: 'product',
            builder:
                (context, state) =>
                    ProductDetailScreen(product: state.extra as Product),
          ),
          GoRoute(
            path: 'product/add',
            builder: (context, state) => const ProductAddScreen(),
          ),
        ],
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/sign_up',
        builder: (context, state) => const SignUpScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BigRoot마트',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}
