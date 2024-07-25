import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserWagePage extends StatefulWidget {
  final int userId;
  final String userName;

  UserWagePage({required this.userId, required this.userName});

  @override
  _UserWagePageState createState() => _UserWagePageState();
}

class _UserWagePageState extends State<UserWagePage> {
  double _hourlyRate = 0;
  int _totalMinutes = 0;
  bool _isLoading = true;
  bool _isAdmin = false;
  Map<int, double> userWages = {};
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAdminAndFetchData();
  }
  
  Future<void> _checkAdminAndFetchData() async {
    try {
      bool isAdmin = await _checkIsAdmin(widget.userId);
      if (mounted) {
        setState(() {
          _isAdmin = isAdmin;
        });
      }

      if (!_isAdmin) {
        await _fetchUserWages();
        _hourlyRate = userWages[widget.userId] ?? 0.0;
        _totalMinutes = await _fetchMemberWorkTime(widget.userId);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      if(jsonDecode(response.body) == 1){
        return true;
      }else{
        return false;
      }
    } else {
      throw Exception('Failed to check if user is admin. Status code: ${response.statusCode}');
    }
  }

  Future<void> _fetchUserWages() async {
    final url = Uri.parse('http://143.248.191.63:3001/get_user_wage');
    final response = await http.get(url);
    print("get_user_wage: ${response.body}");
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        userWages = {
          for (var wageInfo in responseBody)
            int.parse(wageInfo['iduser'].toString()): double.parse(wageInfo['hourly_rate'].toString())
        };
        _controller.text = (userWages[widget.userId] ?? 0.0).toString();
      });
      print('userWages: $userWages');
    } else {
      throw Exception('Failed to load user wages. Status code: ${response.statusCode}');
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
        SnackBar(content: Text('Wage updated successfully')),
      );
    } else {
      throw Exception('Failed to update hourly rate');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double monthlySalary = (_hourlyRate / 60) * _totalMinutes;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}님의 시급'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _isAdmin
              ? Center(
                  child: Text(
                    '직원 전용 페이지입니다.',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.userName}님의 시급',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '현재 시급',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () async {
                              await _updateUserWage();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        '이달의 급여',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '총 ${monthlySalary.toStringAsFixed(2)}원 쌓였어요',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '근무시간 총 ${(_totalMinutes / 60).toStringAsFixed(2)}시간',
                        style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
    );
  }
}
