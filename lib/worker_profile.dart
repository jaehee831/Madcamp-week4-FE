import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_week4_front/main.dart';
import 'dart:convert';
import 'package:madcamp_week4_front/signup/mobile_logout.dart';

class WorkerProfile extends StatefulWidget {
  final int userId;

  const WorkerProfile({super.key, required this.userId});

  @override
  _WorkerProfileState createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0),
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 244, 212),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<String>(
                      future: _getUserName(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Loading...');
                        } else if (snapshot.hasError) {
                          return const Text('Error loading name');
                        } else {
                          return Text('이름: ${snapshot.data}',
                              style: const TextStyle(fontSize: 16.0));
                        }
                      },
                    ),
                    const SizedBox(height: 8.0),
                    FutureBuilder<List<String>>(
                      future: _getStoreNames(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Loading...');
                        } else if (snapshot.hasError) {
                          return const Text('가게 정보를 조회할 수 없습니다.');
                        } else {
                          final stores =
                              snapshot.data?.join(', ') ?? 'No stores';
                          return Text('등록가게: $stores',
                              style: const TextStyle(fontSize: 16.0));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getUserName(int userId) async {
    final url = Uri.parse('http://143.248.191.63:3001/get_user_name');
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

  Future<List<int>> _getStoreList(int userId) async {
    final url = Uri.parse('http://143.248.191.63:3001/get_store_list');
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
    final url = Uri.parse('http://143.248.191.63:3001/get_store_name_list');
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
}
