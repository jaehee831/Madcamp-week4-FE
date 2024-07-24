import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:madcamp_week4_front/admin/admin_profile.dart';
import 'user_wage.dart';
import 'homepage_no_store_worker.dart'; // Ensure this import is correct based on your project structure
import 'channel_board_page.dart';
import 'attendance_bot.dart';
import 'package:madcamp_week4_front/worker_profile.dart';
import 'package:madcamp_week4_front/schedule.dart';
import 'package:madcamp_week4_front/member.dart';
import 'package:madcamp_week4_front/signup/mobile_logout.dart';
import 'package:madcamp_week4_front/signup/signup_owner.dart';

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
  late List<Map<String, dynamic>> tasks = [];
  late Map<int, int> userWages = {};
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getStoreName(widget.storeId);
    _fetchTasks(widget.storeId);
    _fetchUserWages();
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
      throw Exception('Failed to load store ids. Status code: ${response.statusCode}');
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
      setState(() {
        storeName = responseBody['store_name'];
      });
      return responseBody['store_name'];
    } else {
      throw Exception('Failed to load store name. Status code: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> _getStoreData(int userId) async {
    try {
      List<int> storeIds = await _getStoreList(userId);
      List<Map<String, dynamic>> storeData = [];
      for (int storeId in storeIds) {
        String storeName = await _getStoreName(storeId);
        storeData.add({'id': storeId, 'name': storeName});
      }
      return storeData;
    } catch (e) {
      throw Exception('Failed to load store data: $e');
    }
  }

  void _showChannelChangePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _getStoreData(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                title: const Text('채널 변경'),
                content: SizedBox(
                  width: double.minPositive,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('채널 변경'),
                content: SizedBox(
                  width: double.minPositive,
                  child: Center(child: Text('Failed to load stores')),
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
            } else {
              final storeData = snapshot.data ?? [];
              return AlertDialog(
                title: const Text('채널 변경'),
                content: SizedBox(
                  width: double.minPositive,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (var store in storeData)
                        ListTile(
                          title: Text(store['name']),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  userId: widget.userId,
                                  storeId: store['id'],
                                ),
                              ),
                            );
                          },
                        ),
                      ListTile(
                        title: const Text('+ 채널 추가하기'),
                        onTap: () async {
                          bool isAdmin = await _checkIsAdmin(widget.userId);
                          String nickname = await _fetchUserName(widget.userId);
                          if (isAdmin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupOwner(
                                  userId: widget.userId,
                                  nickname: nickname,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomepageNoStoreWorker(userId: widget.userId),
                              ),
                            );
                          }
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
            }
          },
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
    if(index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            userId: widget.userId,
            storeId: widget.storeId
          ),
        ),
      );
    } else if(index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Member(userId: widget.userId, storeId: widget.storeId),
        ),
      );
    } else if (index == 2) {
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
                logoutFromKakao(
                  onLogoutSuccess: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacementNamed(context, '/'); // 로그아웃 성공 시 메인 화면으로 이동
                  },
                  onLogoutFailed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '업무 시간표',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  for (var task in tasks)
                    if (DateTime.parse(task['start_time']).day == DateTime.now().day) 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${task['start_time'].substring(11, 16)}~${task['end_time'].substring(11, 16)}  ${task['task_name']}',
                            style: TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                          SizedBox(height: 4.0),
                        ],
                      ),
                ],
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
                    _onWagePressed(widget.userId);
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
              child: FutureBuilder<bool>(
                future: _checkIsAdmin(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text(
                      '오류 발생',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    );
                  } else {
                    final isAdmin = snapshot.data ?? false;
                    if (isAdmin) {
                      return const Text(
                        '직원 전용 페이지입니다.',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      );
                    } else {
                      return FutureBuilder<int>(
                        future: _fetchMemberWorkTime(widget.userId),
                        builder: (context, timeSnapshot) {
                          if (timeSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (timeSnapshot.hasError) {
                            return const Text(
                              '오류 발생',
                              style: TextStyle(fontSize: 14.0, color: Colors.grey),
                            );
                          } else {
                            final totalMinutes = timeSnapshot.data ?? 0;
                            final hourlyRate = userWages[widget.userId] ?? 0;
                            final monthlySalary = (hourlyRate / 60) * totalMinutes;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '이번 달 월급',
                                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '${monthlySalary.toStringAsFixed(0)} 원 쌓였어요',
                                  style: const TextStyle(fontSize: 14.0, color: Colors.black),
                                ),
                              ],
                            );
                          }
                        },
                      );
                    }
                  }
                },
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

  void _onWagePressed(int userId) async {
    bool isAdmin = await _checkIsAdmin(userId);
    if (isAdmin) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('알림'),
            content: const Text('직원 전용 페이지입니다'),
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
      return;
    }
    try {
      String userName = await _fetchUserName(userId);
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
  }

  Future<void> _fetchUserWages() async {
    final url = Uri.parse('http://143.248.191.173:3001/get_user_wage');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        userWages = {
          for (var wageInfo in responseBody)
            wageInfo['iduser']: int.parse(wageInfo['hourly_rate'].toString().split('.')[0])
        };
      });
    } else {
      throw Exception('Failed to load user wages. Status code: ${response.statusCode}');
    }
  }

  Future<int> _fetchMemberWorkTime(int userId) async {
    final url = Uri.parse('http://143.248.191.173:3001/get_member_work_time?user_id=$userId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'}
    );
    print('get_member_work_time: ${response.body}');
    print('get_member_work_time: ${response.statusCode}');
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final records = responseBody['records'];
      int totalMinutes = 0;
      for (var record in records) {
        DateTime checkIn = DateTime.parse(record['check_in_time']);
        DateTime checkOut = DateTime.parse(record['check_out_time']);
        DateTime breakStart = DateTime.parse(record['break_start_time']);
        DateTime breakEnd = DateTime.parse(record['break_end_time']);
        totalMinutes += checkOut.difference(checkIn).inMinutes;
        totalMinutes -= breakEnd.difference(breakStart).inMinutes;
      }
      return totalMinutes;
    } else if (responseBody.containsKey('message') && responseBody['message'] == 'No records found for the specified user_id') {
      return 0;
    } else {
      throw Exception('Failed to load work time. Status code: ${response.statusCode}');
    }
  }

  Future<void> _fetchTasks(int storeId) async {
    final url = Uri.parse('http://143.248.191.173:3001/get_tasks');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'store_id': storeId}),
    );
    print('get_tasks: Response Body: ${response.body}');
    print('get_tasks: Response Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        DateTime today = DateTime.now();
        setState(() {
        tasks = List<Map<String, dynamic>>.from(responseBody)
          .where((task) => DateTime.parse(task['start_time']).day == today.day)
          .toList();
      });
      } else if (responseBody is Map && responseBody.containsKey('message')) {
        print('no registered tasks in the store');
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load tasks in the store. Status code: ${response.statusCode}');
    }
  }


  Future<bool> _checkIsAdmin(int userId) async {
    final url = Uri.parse('http://143.248.191.173:3001/check_isadmin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    print("check_isadmin: ${response.body}");
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