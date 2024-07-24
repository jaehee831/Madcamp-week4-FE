import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:madcamp_week4_front/homepage.dart';
import 'package:madcamp_week4_front/worker_profile.dart';
import 'package:madcamp_week4_front/member.dart';
import 'package:madcamp_week4_front/attendance_bot.dart';

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
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerProfile(userId: widget.userId)),
                );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('등록된 채널이 없어요'),
            SizedBox(height: 10),
            Text('채널을 등록해 주세요'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChannelAdd(userId: widget.userId),
                  ),
                );
              },
              child: Text('채널 추가하기'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('등록된 가게가 없어 멤버를 조회할 수 없습니다'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
        title: Text('채널 추가하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('채널 비밀번호를 입력하세요'),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '비밀번호',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSubmit,
              child: Text('확인'),
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
            builder: (context) => HomePage(userId: widget.userId, storeId: storeId,),
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
    final url = Uri.parse('http://143.248.191.173:3001/get_store_id');
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
    final url = Uri.parse('http://143.248.191.173:3001/save_user_store');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'user_id': userId.toString(), 'store_id': storeId.toString()}),
    );
    return response.statusCode == 200;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('오류'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('확인'),
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
