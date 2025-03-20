import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController pwdTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'BigRoot 마트',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 150),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailTextEditingController,
                    decoration: const InputDecoration(
                      labelText: '이메일',
                      hintText: '이메일',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty){ return '이메일을 입력 하세요.';}
                      if (value.contains('@')){return '이메일 형식이 아닙니다.';}
                      return null; // 정상일경우 로직은 아직 대기.
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: pwdTextEditingController,
                    decoration: const InputDecoration(
                      labelText: '비밀번호',
                      hintText: '비밀번호',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력 하세요.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: MaterialButton(
              onPressed: () {},
              color: Colors.red,
              minWidth: double.infinity,
              height: 48,
              child: const Text(
                '로그인',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('계정이 없나요? 회원가입')),
        ],
      ),
    );
  }
}
