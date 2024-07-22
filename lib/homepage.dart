import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:madcamp_week4_front/admin/admin_profile.dart';
import 'salary_details_page.dart'; // Import the new screen
import 'homepage_no_store_worker.dart'; // Ensure this import is correct based on your project structure
import 'channel_board_page.dart'; // Import the new channel board page
import 'package:madcamp_week4_front/worker_profile.dart';
import 'package:madcamp_week4_front/worker_salary.dart';
import 'package:madcamp_week4_front/schedule.dart';

class HomePage extends StatefulWidget {
  final int userId;
  final int storeId;

  const HomePage({
    super.key,
    required this.userId,
    required this.storeId
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String storeName = '';

  @override
  void initState() {
    super.initState();
    _getStoreName(widget.storeId);
  }

  void _showChannelChangePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('채널 변경'),
          content: Container(
            width: double.minPositive,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text('버거킹 공동점'),
                  onTap: () {
                    // 채널 변경 로직 추가
                  },
                ),
                ListTile(
                  title: Text('엔제리너스 어은점'),
                  onTap: () {
                    // 채널 변경 로직 추가
                  },
                ),
                ListTile(
                  title: Text('+ 채널 추가하기'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomepageNoStoreWorker(userId: widget.userId)), // Make sure the import is correct
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToChannelBoard(BuildContext context, String channelName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChannelBoardPage(channelName: channelName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(storeName),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              _onPersonPressed(widget.userId);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: GestureDetector(
                onTap: () => _showChannelChangePopup(context),
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz),
                    SizedBox(width: 8.0),
                    Text(
                      '채널 변경',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.announcement),
              title: Text('공지방'),
              onTap: () => _navigateToChannelBoard(context, '공지방'),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('인수인계방'),
              onTap: () => _navigateToChannelBoard(context, '인수인계방'),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('잡담방'),
              onTap: () => _navigateToChannelBoard(context, '잡담방'),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('대타구하기방'),
              onTap: () => _navigateToChannelBoard(context, '대타구하기방'),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('방 추가하기'),
              onTap: () {
                // 방 추가하기 클릭 시 동작 추가
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('로그아웃'),
              onTap: () {
                // 로그아웃 클릭 시 동작 추가
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 공지 섹션
            const Text(
              '공지',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                '7/20 사정일 사정으로 휴무합니다',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),
            // 업무 시간표 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '업무 시간표',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Schedule(userId: widget.userId, storeId: widget.storeId))
                    );
                  },
                  child: const Text('더보기'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                '여기는 시간표~~',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),
            // 급여 계산 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '급여 계산',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SalaryDetailsPage()), // Navigate to the new screen
                    );
                  },
                  child: const Text('더보기'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                '여기는 급여~~',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }

  void _onPersonPressed(int userId) async {
    bool isAdmin = await _checkIsAdmin(userId);
    if(isAdmin){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminProfile(userId: userId)),
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkerProfile(userId: userId)),
      );
    }
  }

  Future<void> _getStoreName(int storeId) async {
    final url = Uri.parse('http://143.248.191.173:3001/get_store_name_list');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'store_id': storeId}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        storeName = responseBody['store_name'];
      });
    } else {
      throw Exception('Failed to load store name. Status code: ${response.statusCode}');
    }
  }

  Future<bool> _checkIsAdmin(int userId) async {
    final url = Uri.parse('http://143.248.191.173:3001/check_isadmin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    if (response.statusCode == 200) {
      if(jsonDecode(response.body) == 1){
        return true;
      }else{
        return false;
      }
    } else {
      throw Exception('Failed to check if user is admin. Status code: ${response.statusCode}');
    }
  }
}