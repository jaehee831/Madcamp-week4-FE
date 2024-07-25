import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:madcamp_week4_front/admin/admin_money_detail.dart';
import 'package:madcamp_week4_front/main.dart';
import 'package:madcamp_week4_front/signup/mobile_logout.dart';

class moneyChooseStore extends StatefulWidget {
  final int userId;

  const moneyChooseStore({super.key, required this.userId});

  @override
  _moneyChooseStoreState createState() => _moneyChooseStoreState();
}

class _moneyChooseStoreState extends State<moneyChooseStore> {
  late Future<List<Map<String, dynamic>>> storeFuture;

  @override
  void initState() {
    super.initState();
    storeFuture = _fetchStores(widget.userId);
  }

  Future<List<Map<String, dynamic>>> _fetchStores(int userId) async {
    final storeListUrl = Uri.parse('http://143.248.191.63:3001/get_store_list');
    final storeNameUrl =
        Uri.parse('http://143.248.191.63:3001/get_store_name_list');

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
        title: const Text('급여조회'),
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
                          builder: (context) => AdminMoney(
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

class AdminMoney extends StatefulWidget {
  final int storeId;
  final int userId;

  const AdminMoney({super.key, required this.storeId, required this.userId});

  @override
  _AdminMoneyState createState() => _AdminMoneyState();
}

class _AdminMoneyState extends State<AdminMoney> {
  List<Map<String, dynamic>> members = [];
  Map<int, int> userWages = {};

  @override
  void initState() {
    super.initState();
    _fetchMembersAndWages(widget.storeId);
  }

  Future<void> _fetchMembersAndWages(int storeId) async {
    try {
      await _fetchMembers(storeId);
      await _fetchUserWages();
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
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
      members = List<Map<String, dynamic>>.from(responseBody);
      for (var member in members) {
        member['user_id'] = int.parse(member['user_id'].toString());
        member['hours'] = await _fetchMemberWorkTime(member['user_id']);
        print('Member ${member['user_id']} hours: ${member['hours']}');
      }
      setState(() {
        members = members;
      });
      print('members: $members');
    } else {
      throw Exception(
          'Failed to load store members. Status code: ${response.statusCode}');
    }
  }

  Future<void> _fetchUserWages() async {
    final url = Uri.parse('http://143.248.191.63:3001/get_user_wage');
    final response = await http.get(url);
    print("get_user_wage: ${response.body}");
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      userWages = {
        for (var wageInfo in responseBody)
          int.parse(wageInfo['iduser'].toString()):
              double.parse(wageInfo['hourly_rate']).toInt()
      };
      print('userWages: $userWages');
    } else {
      throw Exception(
          'Failed to load user wages. Status code: ${response.statusCode}');
    }
  }

  Future<int> _fetchMemberWorkTime(int userId) async {
    final url = Uri.parse(
        'http://143.248.191.63:3001/get_member_work_time?user_id=$userId');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    print("get_member_work_time: ${response.statusCode}");
    print("get_member_work_time: ${response.body}");
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('records')) {
        final records = responseBody['records'] as List<dynamic>;
        int totalMinutes = 0;
        DateTime now = DateTime.now();
        for (var record in records) {
          var recordMap = record as Map<String, dynamic>;
          DateTime checkIn = DateTime.parse(recordMap['check_in_time']);
          DateTime checkOut = DateTime.parse(recordMap['check_out_time']);
          DateTime breakStart = DateTime.parse(recordMap['break_start_time']);
          DateTime breakEnd = DateTime.parse(recordMap['break_end_time']);
          if (checkIn.month == now.month && checkIn.year == now.year) {
            totalMinutes += checkOut.difference(checkIn).inMinutes;
            totalMinutes -= breakEnd.difference(breakStart).inMinutes;
          }
        }
        print('Total minutes for user $userId: $totalMinutes');
        return totalMinutes; // Return total minutes
      } else {
        throw Exception('Unexpected response format.');
      }
    } else if (responseBody.containsKey('message') &&
        responseBody['message'] ==
            'No records found for the specified user_id') {
      return 0;
    } else {
      throw Exception(
          'Failed to load work time. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text('${now.month}월 급여 조회'),
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
                final hourlyRate = userWages[member['user_id']] ?? 0;
                final totalMinutes = member['hours'] ?? 0;
                final monthlySalary = (hourlyRate / 60) * totalMinutes;
                return ListTile(
                  title: Text(member['name']),
                  subtitle: Text('${monthlySalary.toStringAsFixed(0)}원'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoneyDetail(
                          name: member['name'],
                          hours: (totalMinutes / 60).floor(),
                          salary: monthlySalary.toInt(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class AttendanceListItem extends StatelessWidget {
  final String name;
  final String money;

  const AttendanceListItem({
    super.key,
    required this.name,
    required this.money,
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
            money,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
