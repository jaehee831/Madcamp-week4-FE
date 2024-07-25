import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:madcamp_week4_front/admin/admin_attendance_detail.dart';
import 'package:madcamp_week4_front/main.dart';
import 'package:madcamp_week4_front/signup/mobile_logout.dart';

class attendanceChooseStore extends StatefulWidget {
  final int userId;

  const attendanceChooseStore({super.key, required this.userId});

  @override
  _attendanceChooseStoreState createState() => _attendanceChooseStoreState();
}

class _attendanceChooseStoreState extends State<attendanceChooseStore> {
  late Future<List<Map<String, dynamic>>> storeFuture;

  @override
  void initState() {
    super.initState();
    storeFuture = _fetchStores(widget.userId);
  }

  Future<List<Map<String, dynamic>>> _fetchStores(int userId) async {
    final storeListUrl = Uri.parse('http://143.248.191.63:3001/get_store_list');
    final storeNameUrl = Uri.parse('http://143.248.191.63:3001/get_store_name_list');

    final storeListResponse = await http.post(
      storeListUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId.toString()}),
    );

    if (storeListResponse.statusCode != 200) {
      throw Exception('Failed to load store ids');
    } else if (jsonDecode(storeListResponse.body).containsKey('message')) {
      throw Exception('No store registered');
    }

    final storeIds =
        List<int>.from(jsonDecode(storeListResponse.body)['storeIds']);
    final List<Map<String, dynamic>> stores = [];

    for (int storeId in storeIds) {
      final storeNameResponse = await http.post(
        storeNameUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'store_id': storeId.toString()}),
      );

      if (storeNameResponse.statusCode == 200) {
        final storeName = jsonDecode(storeNameResponse.body)['store_name'];
        stores.add({'store_id': storeId, 'store_name': storeName});
      }
    }

    return stores;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('출석부'),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: storeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('등록된 가게가 없습니다.'));
          } else {
            final stores = snapshot.data!;
            return ListView(
              children: stores.map((store) {
                return ListTile(
                  title: Text(store['store_name']),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminAttendance(
                              storeId: store['store_id'],
                              userId: widget.userId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // 버튼 색상 설정
                    ),
                    child:
                        const Text('선택', style: TextStyle(color: Colors.black)),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

class AdminAttendance extends StatefulWidget {
  final int storeId;
  final int userId;

  const AdminAttendance(
      {super.key, required this.storeId, required this.userId});

  @override
  _AdminAttendanceState createState() => _AdminAttendanceState();
}

class _AdminAttendanceState extends State<AdminAttendance> {
  List<Map<String, dynamic>> members = [];

  @override
  void initState() {
    super.initState();
    _fetchMembers(widget.storeId);
  }

  Future<void> _fetchMembers(int storeId) async {
    final url = Uri.parse('http://143.248.191.63:3001/get_store_members');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'store_id': storeId}),
    );
    print("get_store_members: ${response.body}");
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      List<Map<String, dynamic>> fetchedMembers =
          List<Map<String, dynamic>>.from(responseBody);
      for (var member in fetchedMembers) {
        member['hours'] = await _fetchMemberWorkTime(member['user_id']);
      }
      setState(() {
        members = fetchedMembers;
      });
    } else {
      throw Exception(
          'Failed to load store members. Status code: ${response.statusCode}');
    }
  }

  Future<String> _fetchMemberWorkTime(int userId) async {
    final url = Uri.parse('http://143.248.191.63:3001/get_member_work_time?user_id=$userId');
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
        if (record['check_in_time'] != null && 
            record['check_out_time'] != null && 
            record['break_start_time'] != null && 
            record['break_end_time'] != null) {
          
          DateTime checkIn = DateTime.parse(record['check_in_time']);
          DateTime checkOut = DateTime.parse(record['check_out_time']);
          DateTime breakStart = DateTime.parse(record['break_start_time']);
          DateTime breakEnd = DateTime.parse(record['break_end_time']);
          
          totalMinutes += checkOut.difference(checkIn).inMinutes;
          totalMinutes -= breakEnd.difference(breakStart).inMinutes;
        }
      }
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      return '$hours시간 $minutes분';
    } else if (responseBody.containsKey('message') &&
        responseBody['message'] ==
            'No records found for the specified user_id') {
      return '0시간 0분';
    } else {
      throw Exception(
          'Failed to load work time. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('출석부'),
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
      body: members.isEmpty
          ? const Center(child: Text('해당 가게에 등록한 직원이 없습니다.'))
          : ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Column(
                  children: [
                    ListTile(
                      title: AttendanceListItem(
                        name: member['name'],
                        hours: member['hours'],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminAttendanceDetail(
                              userId: member['user_id'],
                              userName: member['name'],
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
    );
  }
}

class AttendanceListItem extends StatelessWidget {
  final String name;
  final String hours;

  const AttendanceListItem({
    super.key,
    required this.name,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16.0),
              Text(
                name,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          Text(
            hours,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
