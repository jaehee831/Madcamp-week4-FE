import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'signup_worker.dart'; 
import 'signup_owner.dart';
import 'dart:convert';

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
              onPressed: () async {
                bool userSaveSuccess = await _sendUserIdToServer(userId, nickname, 0); // 서버에 사용자 ID 전송
                if(userSaveSuccess){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupWorker(userId: userId, nickname: nickname),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.3, screenHeight * 0.3), // 버튼 크기 설정
              ),
              child: const Text('알바'),
            ),
            SizedBox(width: screenWidth * 0.1),
            ElevatedButton(
              onPressed: () async {
                bool userSaveSuccess = await _sendUserIdToServer(userId, nickname, 1); // 서버에 사용자 ID 전송
                if(userSaveSuccess){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupOwner(userId: userId, nickname: nickname),
                    ),
                  );
                }
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

Future<bool> _sendUserIdToServer(int userId, String nickname, int isAdmin) async {
  final url = Uri.parse('http://143.248.191.160:3001/save_user');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'iduser': userId.toString(),
      'name': nickname,
      'is_admin': isAdmin.toString(),
    }),
  );
  if (response.statusCode == 200) {
    final responseBody = jsonDecode(response.body);
    if (responseBody['status'] == 'success' || responseBody['message'] == 'User already exists') {
      print('User ID saved successfully or user already exists');
      return true;
    } else {
      print('Unexpected response: ${responseBody['message']}');
      return false;
    }
  } else {
    print('Failed to save user ID. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return false;
  }
}