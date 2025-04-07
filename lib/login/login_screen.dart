import 'package:big_root_market/login/provider/login_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    //구글 로그인
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //구글 인증이 되었는지.
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/fastcampus_logo.png'), // 여기서 부터 진행.
            const Text(
              'BigRoot 마트',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 64),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: '이메일',
                      hintText: '이메일',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력 하세요.';
                      }
                      if (!value.contains('@')) {
                        return '이메일 형식이 아닙니다.';
                      }
                      return null; // 정상일경우 로직은 아직 대기.
                    },
                    onSaved: (value) => _email = value!.trim(),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: '비밀번호',
                      hintText: '비밀번호',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력 하세요.';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value!.trim(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return MaterialButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // 각 필드 별 onSaved() 호출.

                      final result = await signIn(_email, _password);

                      if (!context.mounted) return;
                      //실패시 동작
                      if (result == null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('로그인 실패')));
                        return;
                      }
                      ref.watch(userProvider.notifier).state = result;
                      //성공시 동작
                      debugPrint('BIGROOT : 로그인 성공');
                      context.go('/');
                    }
                  },

                  color: Colors.red,
                  minWidth: double.infinity,
                  height: 48,
                  child: const Text(
                    '로그인',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              },
            ),
            TextButton(
              /*
              onPressed: () {
                GoRouter.of(context).push('/sign_up');
              },
              */
              onPressed: () => context.push('/sign_up'),
              child: const Text('계정이 없나요? 회원가입'),
            ),
            const Divider(),
            InkWell(
              onTap: () async {
                final result = await signInWithGoogle();

                if (!context.mounted) return;
                if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('구글 로그인에 실패하였습니다.')),
                  );
                }

                debugPrint('BIG ROOT: 구글 로그인 성공');
                context.go('/');
              },
              child: Image.asset('assets/btn_google_signin.png'),
            ),
          ],
        ),
      ),
    );
  }
}
