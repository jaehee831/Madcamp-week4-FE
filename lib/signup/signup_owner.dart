import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'dart:convert';
import 'package:madcamp_week4_front/homepage.dart';

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
        builder: (context) => SignupStoreRegister(userId: widget.userId, storeName: storeName),
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

class SignupStoreRegister extends StatefulWidget {
  final int userId;
  final String storeName;

  const SignupStoreRegister({
    super.key,
    required this.storeName,
    required this.userId
  });

  @override
  _SignupStoreRegisterState createState() => _SignupStoreRegisterState();
}

class _SignupStoreRegisterState extends State<SignupStoreRegister> {
  late String randomKey;
  late String storeId;

  @override
  void initState() {
    super.initState();
    _processStoreRegistration();
  }

  Future<void> _processStoreRegistration() async {
    await _saveStore();
    await _getStoreIdFromPassword(randomKey);
    await _saveOwnerStore(storeId.toString());
    setState(() {});
  }

  Future<void> _saveStore() async {
    final random = Random();
    randomKey = random.nextInt(1000000).toString().padLeft(6, '0');

    final url = Uri.parse('http://143.248.191.160:3001/save_store');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': widget.storeName,
        'password': randomKey
      })
    );
    if (response.statusCode == 200) {
      print('Store saved successfully');
    } else {
      print('Failed to save Store');
    }
  }

  Future<void> _getStoreIdFromPassword(String password) async {
    final url = Uri.parse('http://143.248.191.160:3001/get_store_id');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'password': password
      })
    );
    if (response.statusCode == 200) {
      final responseBody = response.body;
      storeId = jsonDecode(responseBody)['idstores'];
      print('Store ID: $storeId');
    } else {
      print('Failed to get Store ID');
    }
  }

  Future<void> _saveOwnerStore(String storeId) async {
    final url = Uri.parse('http://143.248.191.160:3001/save_user_store');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': widget.userId.toString(),
        'store_id': storeId
      })
    );
    if (response.statusCode == 200) {
      print('UserStore saved successfully');
    } else {
      print('Failed to save UserStore');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가게 등록 완료'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('가게 "${widget.storeName}"가 성공적으로 등록되었습니다!'),
            const SizedBox(height: 20), // 간격 추가
            const Text('암호키발급'),
            Text(randomKey, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20), // 간격 추가
            ElevatedButton(
              onPressed: () {
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