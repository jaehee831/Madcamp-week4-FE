import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'signup_worker.dart'; 
import 'signup_owner.dart';
import 'package:madcamp_week4_front/homepage.dart';
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
                  await _onWorkerConfirmPressed(context, userId, nickname);
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
                  await _onOwnerConfirmPressed(context, userId, nickname);
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

Future<void> _onOwnerConfirmPressed(BuildContext context, int userId, String nickname) async {
  try {
    bool ownerRegisterStore = await _checkUserRegisterStore(userId);
    if (ownerRegisterStore) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupOwner(userId: userId, nickname: nickname),
        ),
      );
    }
  } catch (e) {
    print(e); // 예외 메시지를 출력
  }
}

Future<void> _onWorkerConfirmPressed(BuildContext context, int userId, String nickname) async {
  try {
    bool workerRegisterStore = await _checkUserRegisterStore(userId);
    if (workerRegisterStore) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupWorker(userId: userId, nickname: nickname),
        ),
      );
    }
  } catch (e) {
    print(e); // 예외 메시지를 출력
  }
}

Future<bool> _sendUserIdToServer(int userId, String nickname, int isAdmin) async {
  final url = Uri.parse('http://143.248.191.173:3001/save_user');
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

Future<bool> _checkUserRegisterStore(int userId) async {
  final url = Uri.parse('http://143.248.191.173:3001/get_store_list');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId}),
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  if (response.statusCode == 200) {
    final responseBody = jsonDecode(response.body);
    if (responseBody.containsKey('storeIds')) {
      return true;
    } else {
      print('No store registered');
      return false;
    }
  } else if (response.statusCode == 400) {
    final responseBody = jsonDecode(response.body);
    throw Exception('Missing Fields: ${responseBody['error']}');
  } else {
    throw Exception('Failed to load store ids. Status code: ${response.statusCode}');
  }
}


