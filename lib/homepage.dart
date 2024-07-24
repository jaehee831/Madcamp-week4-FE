import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:madcamp_week4_front/admin/admin_profile.dart';
import 'user_wage.dart';
import 'homepage_no_store_worker.dart'; // Ensure this import is correct based on your project structure
import 'channel_board_page.dart';
import 'attendance_bot.dart';
import 'channel_board_page.dart'; // Import the new channel board page
import 'package:madcamp_week4_front/worker_profile.dart';
import 'package:madcamp_week4_front/worker_salary.dart';
import 'package:madcamp_week4_front/schedule.dart';

class HomePage extends StatefulWidget {
  final int userId;
  final int storeId;

  const HomePage({super.key, required this.userId, required this.storeId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _notice = '공지 사항을 불러오는 중...';
  String storeName = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getStoreName(widget.storeId);
    _fetchNotice();
    _fetchRooms();
  }

  Future<void> _fetchNotice() async {
    final url = Uri.parse('http://143.248.191.173:3001/get_notice');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _notice = data['content'];
      });
    } else {
      setState(() {
        _notice = '공지 사항을 불러오지 못했습니다.';
      });
    }
  }

  Future<String> _fetchUserName(int userId) async {
    final response = await http.post(
      Uri.parse('http://143.248.191.173:3001/get_user_name'),
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

  List<Map<String, dynamic>> _rooms = [];

  Future<void> _fetchRooms() async {
    final url = Uri.parse('http://143.248.191.173:3001/get_boards');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _rooms = List<Map<String, dynamic>>.from(data);
      });
    } else {
      _rooms = [];
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
            ..._rooms.map((room) => ListTile(
                  leading: const Icon(Icons.group),
                  title: Text(room['title'] ?? '방 이름 없음'),
                  onTap: () => _navigateToChannelBoard(
                      context, room['title'] ?? '방 이름 없음'), // null 값을 처리
                )),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('방 추가하기'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RoomDialog(
                      onRoomAdded: (room) {
                        setState(() {
                          _rooms.add(room);
                        });
                      },
                    );
                  },
                );
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
              child: Text(
                _notice,
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
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
                        MaterialPageRoute(
                            builder: (context) => Schedule(
                                userId: widget.userId,
                                storeId: widget.storeId)));
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

  void _onPersonPressed(int userId) async {
    bool isAdmin = await _checkIsAdmin(userId);
    if (isAdmin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminProfile(userId: userId)),
      );
    } else {
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
      throw Exception(
          'Failed to load store name. Status code: ${response.statusCode}');
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
      if (jsonDecode(response.body) == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception(
          'Failed to check if user is admin. Status code: ${response.statusCode}');
    }
  }
}

class RoomDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onRoomAdded;
  RoomDialog({required this.onRoomAdded});

  @override
  _RoomDialogState createState() => _RoomDialogState();
}

class _RoomDialogState extends State<RoomDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _addRoom() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('방 이름을 입력하세요')),
      );
      return;
    }

    final url = Uri.parse('http://143.248.191.173:3001/add_board');
    print('Adding room with name: $name and description: $description'); 
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'description': description}),
    );

    if (response.statusCode == 201) {
      widget.onRoomAdded({
        'title': name,
        'description': description,
      });
      Navigator.of(context).pop();
    } else {
      print('Failed to add room. Response status: ${response.statusCode}, body: ${response.body}'); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('방 추가에 실패했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('방 추가하기'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '방 이름',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: '설명',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _addRoom,
          child: const Text('작성 완료'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('닫기'),
        ),
      ],
    );
  }
}
