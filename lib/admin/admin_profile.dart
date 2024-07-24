import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/admin/channel_delete.dart';
import 'package:madcamp_week4_front/admin/admin.dart';
import 'package:madcamp_week4_front/main.dart';
import 'package:madcamp_week4_front/signup/mobile_logout.dart';

class AdminProfile extends StatefulWidget {
  final int userId;

  const AdminProfile({
    super.key,
    required this.userId,
  });

  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  late Future<List<String>> storeNamesFuture;
  late Future<String> userNameFuture;

  @override
  void initState() {
    super.initState();
    storeNamesFuture = _getStoreNames(widget.userId);
    userNameFuture = _getUserName(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logoutFromKakao(
                onLogoutSuccess: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(
                      context, '/'); // 로그아웃 성공 시 메인화면으로 이동
                },
                onLogoutFailed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('로그아웃 실패'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            const CircleAvatar(
              radius: 80,
              backgroundColor: Color(0xFFFFF0BA),
              backgroundImage: AssetImage('assets/images/광대.png'),
            ),
            const SizedBox(height: 24.0),
            FutureBuilder<String>(
              future: userNameFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('이름', style: TextStyle(fontSize: 20.0)),
                      const SizedBox(height: 16.0),
                      Text(snapshot.data!,
                          style: const TextStyle(fontSize: 16.0)),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 24.0),
            FutureBuilder<List<String>>(
              future: storeNamesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('등록된 가게가 없습니다.'));
                } else {
                  final storeNames = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('등록가게', style: TextStyle(fontSize: 20.0)),
                      const SizedBox(height: 8.0),
                      ...storeNames.map((storeName) => Text(storeName,
                          style: const TextStyle(fontSize: 16.0))),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Admin(userId: widget.userId)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // 버튼 색상 설정
                  ),
                  child:
                      const Text('관리하기', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChannelDelete()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // 버튼 색상 설정
                  ),
                  child:
                      const Text('채널삭제', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<int>> _getStoreList(int userId) async {
    final url = Uri.parse('http://143.248.191.173:3001/get_store_list');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId.toString()}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('storeIds')) {
        List<int> storeIds = List<int>.from(responseBody['storeIds']);
        return storeIds;
      } else {
        throw Exception('No store registered');
      }
    } else if (response.statusCode == 400) {
      final responseBody = jsonDecode(response.body);
      throw Exception('Missing Fields: ${responseBody['error']}');
    } else {
      throw Exception(
          'Failed to load store ids. Status code: ${response.statusCode}');
    }
  }

  Future<String> _getStoreName(int storeId) async {
    final url = Uri.parse('http://143.248.191.173:3001/get_store_name_list');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'store_id': storeId.toString()}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['store_name'];
    } else {
      throw Exception(
          'Failed to load store name. Status code: ${response.statusCode}');
    }
  }

  Future<List<String>> _getStoreNames(int userId) async {
    try {
      List<int> storeIds = await _getStoreList(userId);
      List<String> storeNames = [];
      for (int storeId in storeIds) {
        String storeName = await _getStoreName(storeId);
        storeNames.add(storeName);
      }
      return storeNames;
    } catch (e) {
      throw Exception('Failed to load store names: $e');
    }
  }

  Future<String> _getUserName(int userId) async {
    final url = Uri.parse('http://143.248.191.173:3001/get_user_name');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['user_name'];
    } else {
      throw Exception(
          'Failed to load user name. Status code: ${response.statusCode}');
    }
  }
}
