import 'package:flutter/material.dart';
import 'signup_worker.dart'; 
import 'signup_owner.dart';

class SignUpRoleSelect extends StatelessWidget {
  final int userId;
  final String nickname;

  const SignUpRoleSelect({
    super.key,
    required this.userId,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupWorker(userId: userId, nickname: nickname),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.3, screenHeight * 0.3), // 버튼 크기 설정
              ),
              child: const Text('알바'),
            ),
            SizedBox(width: screenWidth * 0.1),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupOwner(userId: userId, nickname: nickname),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.3, screenHeight * 0.3), // 버튼 크기 설정
              ),
              child: const Text('점주'),
            ),
          ],
        ),
      ),
    );
  }
}
