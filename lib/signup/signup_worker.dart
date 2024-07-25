import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/homepage_no_store_worker.dart';
import 'package:madcamp_week4_front/main.dart';

class SignupWorker extends StatefulWidget {
  final int userId;
  final String nickname;

  const SignupWorker({
    super.key,
    required this.userId,
    required this.nickname,
  });

  @override
  _SignupWorkerState createState() => _SignupWorkerState();
}

class _SignupWorkerState extends State<SignupWorker> {
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알바생 화면'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/popcorn.png'),
              const SizedBox(height: 20),
              if (widget.nickname.isNotEmpty)
                Text('Hello, ${widget.nickname}!',
                    style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 16),
              const Text('계좌번호를 입력하세요'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _bankController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '은행',
                  ),
                  style: const TextStyle(
                      fontSize: 14.0), // 텍스트 필드의 높이를 줄이기 위해 폰트 크기를 줄임
                ),
              ), // 두 박스 사이의 간격을 줄이기 위해 SizedBox 추가
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _accountNumberController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '계좌번호',
                  ),
                  style: const TextStyle(
                      fontSize: 14.0), // 텍스트 필드의 높이를 줄이기 위해 폰트 크기를 줄임
                ),
              ),

              ElevatedButton(
                onPressed: _onConfirmPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // 버튼 색상 설정
                ),
                child: const Text('확인', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onConfirmPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomepageNoStoreWorker(userId: widget.userId)));
  }
}
