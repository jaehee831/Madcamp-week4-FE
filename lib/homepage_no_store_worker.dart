import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:madcamp_week4_front/homepage.dart';
import 'package:madcamp_week4_front/main.dart';
import 'package:madcamp_week4_front/worker_profile.dart';

class HomepageNoStoreWorker extends StatefulWidget {
  final int userId;

  const HomepageNoStoreWorker({
    super.key,
    required this.userId,
  });

  @override
  _HomepageNoStoreWorkerState createState() => _HomepageNoStoreWorkerState();
}

class _HomepageNoStoreWorkerState extends State<HomepageNoStoreWorker> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkerProfile(userId: widget.userId)),
              );
            },
          ),
        ],
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 패딩을 Center 안으로 옮김
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('등록된 채널이 없어요'),
              const SizedBox(height: 10),
              const Text('채널을 등록해 주세요'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChannelAdd(userId: widget.userId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // 버튼 색상 설정
                ),
                child: const Text('채널 추가하기',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFFFF0BA),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '멤버',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: '출첵',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('등록된 가게가 없어 멤버를 조회할 수 없습니다'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('등록된 가게가 없어 출석체크를 할 수 없습니다'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}

class ChannelAdd extends StatefulWidget {
  final int userId;

  const ChannelAdd({
    super.key,
    required this.userId,
  });

  @override
  _ChannelAddState createState() => _ChannelAddState();
}

class _ChannelAddState extends State<ChannelAdd> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채널 추가하기'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/cake.png'),
            const SizedBox(height: 100),
            const Text(
              '채널 비밀번호를 입력하세요',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '비밀번호',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // 버튼 색상 설정
              ),
              child: const Text('확인', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    String password = _passwordController.text;
    try {
      int storeId = await _getStoreIdFromPassword(password);
      bool success = await _saveUserStore(widget.userId, storeId);
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userId: widget.userId,
              storeId: storeId,
            ),
          ),
        );
      } else {
        _showErrorDialog('채널 등록에 실패했습니다.');
      }
    } catch (e) {
      _showErrorDialog('오류 발생: $e');
    }
  }

  Future<int> _getStoreIdFromPassword(String password) async {
    final url = Uri.parse('http://143.248.191.63:3001/get_store_id');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'password': password}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['idstores'];
    } else {
      throw Exception('Failed to get store ID');
    }
  }

  Future<bool> _saveUserStore(int userId, int storeId) async {
    final url = Uri.parse('http://143.248.191.63:3001/save_user_store');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(
          {'user_id': userId.toString(), 'store_id': storeId.toString()}),
    );
    return response.statusCode == 200;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('오류'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
