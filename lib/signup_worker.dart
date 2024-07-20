import 'package:flutter/material.dart';
import 'homepage.dart';

class SignupWorker extends StatefulWidget {
  final String profileImageUrl;
  final String nickname;

  const SignupWorker({
    super.key,
    required this.profileImageUrl,
    required this.nickname,
  });

  @override
  _SignupWorkerState createState() => _SignupWorkerState();
}

class _SignupWorkerState extends State<SignupWorker> {
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  void _onConfirmPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알바생 화면'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.profileImageUrl.isNotEmpty)
              Image.network(widget.profileImageUrl, width: 100, height: 100),
            if (widget.nickname.isNotEmpty) 
              Text('Hello, ${widget.nickname}!'),
            const SizedBox(height: 20),
            const Text('계좌번호를 입력하세요'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _bankController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '은행',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '계좌번호',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _onConfirmPressed,
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}