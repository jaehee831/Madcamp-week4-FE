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
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserWage();
  }

  Future<void> _fetchUserWage() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3001/get_one_user_wage?user_id=${widget.userId}'),
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
      Uri.parse('http://10.0.2.2:3001/edit_user_wage'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}님의 시급'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
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
                    '총 372,444 원 쌓였어요',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '근무시간 총 17시간',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
    );
  }
}