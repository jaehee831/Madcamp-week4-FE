import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:madcamp_week4_front/admin/admin_profile.dart';
import 'user_wage.dart';
import 'homepage_no_store_worker.dart'; // Ensure this import is correct based on your project structure
import 'channel_board_page.dart';
import 'attendance_bot.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({
    super.key,
    required this.userId,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Future<String> _fetchUserName(int userId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3001/get_user_name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['user_name'];
    } else {
      throw Exception('Failed to load user name');
    }
  }

  void _showChannelChangePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('채널 변경'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text('버거킹 공동점'),
                  onTap: () {
                    // 채널 변경 로직 추가
                  },
                ),
                ListTile(
                  title: const Text('엔제리너스 어은점'),
                  onTap: () {
                    // 채널 변경 로직 추가
                  },
                ),
                ListTile(
                  title: const Text('+ 채널 추가하기'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomepageNoStoreWorker(
                              userId: widget
                                  .userId)), // Make sure the import is correct
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('닫기'),
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

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceBotPage(userId: widget.userId),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('롯데리아 어은점'),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminProfile(userId: widget.userId)),
              );
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
                child: const Row(
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
              leading: const Icon(Icons.announcement),
              title: const Text('공지방'),
              onTap: () => _navigateToChannelBoard(context, '공지방'),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('인수인계방'),
              onTap: () => _navigateToChannelBoard(context, '인수인계방'),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('잡담방'),
              onTap: () => _navigateToChannelBoard(context, '잡담방'),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('대타구하기방'),
              onTap: () => _navigateToChannelBoard(context, '대타구하기방'),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('방 추가하기'),
              onTap: () {
                // 방 추가하기 클릭 시 동작 추가
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
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
                    // 더보기 버튼 동작 추가
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
                  onPressed: () async {
                    try {
                      String userName = await _fetchUserName(widget.userId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserWagePage(
                            userId: widget.userId,
                            userName: userName,
                          ),
                        ),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to load user name')),
                      );
                    }
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
}
