import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'dart:convert';
import 'package:madcamp_week4_front/homepage.dart';
import 'package:madcamp_week4_front/main.dart';

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
        builder: (context) =>
            SignupStoreRegister(userId: widget.userId, storeName: storeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('가게 등록'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/popcorn.png'),
              SizedBox(height: screenHeight * 0.05),
              const Text('아직 등록된 가게가 없어요.',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              const Text('가게를 등록해주세요.',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              SizedBox(height: screenHeight * 0.01),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: kIsWeb
                      ? screenWidth * 0.5
                      : screenWidth * 0.8, // 웹과 모바일에 따라 크기 조정
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '가게 이름',
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              ElevatedButton(
                onPressed: _onRegisterPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // 버튼 색상 설정
                ),
                child: const Text(
                  '등록완료',
                  style: TextStyle(color: Colors.black), // 텍스트 색상 설정
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupStoreRegister extends StatefulWidget {
  final int userId;
  final String storeName;

  const SignupStoreRegister(
      {super.key, required this.storeName, required this.userId});

  @override
  _SignupStoreRegisterState createState() => _SignupStoreRegisterState();
}

class _SignupStoreRegisterState extends State<SignupStoreRegister> {
  late String randomKey = '';
  late int storeId;
  Set<String> existingKeys = {};

  @override
  void initState() {
    super.initState();
    _processStoreRegistration();
  }

  Future<void> _processStoreRegistration() async {
    await _fetchExistingKeys();
    randomKey = _generateUniqueKey();
    await _saveStore();
    await _getStoreIdFromPassword(randomKey);
    await _saveOwnerStore(storeId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가게 등록 완료'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/beer.png'),
            const SizedBox(height: 30),
            Text('가게 "${widget.storeName}"가 성공적으로 등록되었습니다!',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30), // 간격 추가
            const Text('암호키발급'),
            const SizedBox(height: 10),
            Text(randomKey,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30), // 간격 추가
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(userId: widget.userId, storeId: storeId)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // 버튼 색상 설정
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // border radius 30 설정
                ),
              ),
              child: const Text(
                '홈으로 가기',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveStore() async {
    final random = Random();
    randomKey = random.nextInt(1000000).toString().padLeft(6, '0');

    final url = Uri.parse('http://143.248.191.173:3001/save_store');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'store_name': widget.storeName,
          'password': randomKey
        }));
    if (response.statusCode == 200) {
      print('Store saved successfully');
    } else {
      print('Failed to save Store');
    }
  }

  Future<void> _getStoreIdFromPassword(String password) async {
    final url = Uri.parse('http://143.248.191.173:3001/get_store_id');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'password': password}),
    );
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final responseBody = response.body;
      final decodedResponse = jsonDecode(responseBody);
      if (decodedResponse.containsKey('idstores')) {
        storeId = decodedResponse['idstores'];
        print('Store ID: $storeId');
      } else {
        print('Error: idstores key not found in response');
      }
    } else {
      print('Failed to get Store ID: ${response.statusCode}');
    }
  }

  Future<void> _saveOwnerStore(int storeId) async {
    final url = Uri.parse('http://143.248.191.173:3001/save_user_store');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, int>{'user_id': widget.userId, 'store_id': storeId}));
    if (response.statusCode == 200) {
      print('UserStore saved successfully');
    } else {
      print('Failed to save UserStore');
    }
  }

  Future<void> _fetchExistingKeys() async {
    final url = Uri.parse('http://143.248.191.173:3001/get_store_pw_list');
    final response = await http.get(url);

    print("get_store_pw_list: ${response.statusCode}");
    print("get_store_pw_list: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> keys = jsonDecode(response.body);
      existingKeys = keys.map((key) => key.toString()).toSet();
    } else {
      print('Failed to fetch existing keys');
    }
  }

  String _generateUniqueKey() {
    final random = Random();
    String key;
    do {
      key = random.nextInt(1000000).toString().padLeft(6, '0');
    } while (existingKeys.contains(key));
    return key;
  }
}
