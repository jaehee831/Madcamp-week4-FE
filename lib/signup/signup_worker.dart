import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/homepage_no_store_worker.dart';

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
  final TextEditingController _accountNumberController = TextEditingController();

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
            if (widget.userId != 0)
              Text('userId: ${widget.userId}'),
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

  void _onConfirmPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomepageNoStoreWorker(userId: widget.userId))
    );
  }

}