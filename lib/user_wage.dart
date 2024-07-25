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
      _fetchUserWage();
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

  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0), // 수직 여백 추가
                        child: Text(
                          '${widget.userName}님의 시급',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0), // 필요에 따라 수직 여백 추가
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Row의 내용을 가운데 정렬
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right:
                                        8.0), // TextField와 IconButton 사이에 여백 추가
                                child: TextField(
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: '현재 시급',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 64.0, // 필요한 경우 너비 조정
                              height: 64.0, // 필요한 경우 높이 조정
                              child: IconButton(
                                iconSize: 40.0, // 아이콘 크기 조정
                                icon: const Icon(Icons.save),
                                onPressed: () async {
                                  await _updateUserWage();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text('이달의 급여',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      const Text('총 372,444 원 쌓였어요',
                          style: TextStyle(fontSize: 24, color: Colors.blue)),
                      const SizedBox(height: 16),
                      const Text('근무시간 총 17시간',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 117, 148, 46))),
                    ],
                  ),
                ),
    );
  }
}
