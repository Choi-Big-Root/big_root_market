import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  Future<bool> signUp(String emailAddress, String password) async {
    try {
      // auth 이메일, 비밀번호로 사용자 생성.
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      // cloud firestore
      await FirebaseFirestore.instance.collection('users').add({
        'uid': credential.user?.uid ?? '',
        'email': credential.user?.email ?? '',
      });
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-password') {
        debugPrint('등록하실 비밀번호는 6자리 이상의 문자여야 합니다.');
      } else if (e.code == 'invalid-email') {
        debugPrint('이메일이 잘못되었습니다.');
      } else if (e.code == 'email-already-exists') {
        debugPrint('이미 존재하는 이메일 입니다.');
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'BigRoot 마트\n가입을 환영합니다.',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '이메일',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력하세요.';
                          }
                          if (!value.contains('@')) {
                            return '이메일 형식이 아닙니다.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '비밀번호',
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!.trim(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                MaterialButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final result = await signUp(_email, _password);

                      if (!context.mounted) return;

                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('회원가입 성공 하셨습니다.')),
                        );
                        //go() 현재화면을 경로에 맞는 화면으로 변경하는 개념.
                        //go_router 패키지를 사용한다면 pop을 실행후 push를 해야 동일한기능을 할것으로 생각.
                        context.go('/login');
                      }
                    }
                  },
                  minWidth: double.infinity,
                  height: 48,
                  color: Colors.red,
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
