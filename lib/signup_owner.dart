import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'homepage.dart';

class SignupOwner extends StatefulWidget {
  final int userId;
  final String nickname;

  const SignupOwner({
    super.key,
    required this.userId,
    required this.nickname,
  });

  @override
  _SignupOwnerState createState() => _SignupOwnerState();
}

class _SignupOwnerState extends State<SignupOwner> {
  final TextEditingController _controller = TextEditingController();

  void _onRegisterPressed() {
    String storeName = _controller.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupStoreRegister(storeName: storeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('사장님 화면'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('아직 등록된 가게가 없어요. 가게를 등록해주세요.'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: kIsWeb ? screenWidth * 0.5 : screenWidth * 0.8, // 웹과 모바일에 따라 크기 조정
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '가게 이름',
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _onRegisterPressed,
              child: const Text('등록완료'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupStoreRegister extends StatelessWidget {
  final String storeName;

  const SignupStoreRegister({super.key, required this.storeName});

@override
  Widget build(BuildContext context) {
    // 무작위 숫자 생성
    final random = Random();
    final randomKey = random.nextInt(1000000).toString().padLeft(6, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('가게 등록 완료'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('가게 "$storeName"가 성공적으로 등록되었습니다!'),
            const SizedBox(height: 20), // 간격 추가
            const Text('암호키발급'),
            Text(randomKey, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20), // 간격 추가
            ElevatedButton(
              onPressed: () {
                // 홈으로 가기 버튼 클릭 시 다른 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('홈으로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}
