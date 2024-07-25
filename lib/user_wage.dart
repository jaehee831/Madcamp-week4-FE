import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:madcamp_week4_front/main.dart';

class UserWagePage extends StatefulWidget {
  final int userId;
  final String userName;

  const UserWagePage({super.key, required this.userId, required this.userName});

  @override
  _UserWagePageState createState() => _UserWagePageState();
}

class _UserWagePageState extends State<UserWagePage> {
  double _hourlyRate = 0;
  int _totalMinutes = 0;
  bool _isLoading = true;
  bool _isAdmin = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAdminAndFetchData();
  }

  Future<void> _checkAdminAndFetchData() async {
    bool isAdmin = await _checkIsAdmin(widget.userId);
    setState(() {
      _isAdmin = isAdmin;
    });

    if (!_isAdmin) {
      await _fetchUserWage();
      _totalMinutes = await _fetchMemberWorkTime(widget.userId);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _checkIsAdmin(int userId) async {
    final url = Uri.parse('http://143.248.191.63:3001/check_isadmin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    print("check_isadmin: ${response.body}");
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

  Future<void> _fetchUserWage() async {
    final response = await http.get(
      Uri.parse(
          'http://143.248.191.63:3001/get_one_user_wage?user_id=${widget.userId}'),
    );
    print('get_one_user_wage: ${response.body}');
    print('get_one_user_wage: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _hourlyRate = double.parse(data['hourly_rate'].toString());
        _controller.text = _hourlyRate.toString();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load hourly rate');
    }
  }

  Future<void> _updateUserWage() async {
    final newRate = double.tryParse(_controller.text);
    if (newRate == null) return;

    final response = await http.put(
      Uri.parse('http://143.248.191.63:3001/edit_user_wage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'iduser': widget.userId,
        'hourly_rate': newRate,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _hourlyRate = newRate;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wage updated successfully')),
      );
    } else {
      throw Exception('Failed to update hourly rate');
    }
  }

  Future<int> _fetchMemberWorkTime(int userId) async {
    final url = Uri.parse(
        'http://143.248.191.63:3001/get_member_work_time?user_id=$userId');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
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
    final double monthlySalary = (_hourlyRate / 60) * _totalMinutes;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}님의 시급'),
        backgroundColor: primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isAdmin
              ? const Center(
                  child: Text(
                    '직원 전용 페이지입니다.',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                )
              : Center(
                  // Center 위젯 추가
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
                      mainAxisAlignment: MainAxisAlignment.center, // 세로 가운데 정렬
                      children: [
                        Text(
                          '${widget.userName}님의 시급',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: '현재 시급',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () async {
                                await _updateUserWage();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '이달의 급여',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '총 ${monthlySalary.toStringAsFixed(2)}원 쌓였어요',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.blue),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '근무시간 총 ${(_totalMinutes / 60).toStringAsFixed(2)}시간',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
