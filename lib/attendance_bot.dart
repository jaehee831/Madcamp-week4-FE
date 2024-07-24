import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceBotPage extends StatefulWidget {
  final int userId;

  const AttendanceBotPage({super.key, required this.userId});

  @override
  _AttendanceBotPageState createState() => _AttendanceBotPageState();
}

class _AttendanceBotPageState extends State<AttendanceBotPage> {
  List<Map<String, String>> logs = [];

  Future<void> _recordAttendance(String type) async {
    final DateTime now = DateTime.now();
    final String formattedTime =
        "${now.month}/${now.day} ${now.hour}:${now.minute}";

    const String apiUrl = 'http://143.248.191.173:3001/attendance_record';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': 1,
        'type': type,
        'time': now.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        logs.add({'time': formattedTime, 'type': _getTypeString(type)});
      });
    } else {
      throw Exception('Failed to record attendance');
    }
  }

  String _getTypeString(String type) {
    switch (type) {
      case 'check_in_time':
        return '출근';
      case 'check_out_time':
        return '퇴근';
      case 'break_start_time':
        return '휴식 시작';
      case 'break_end_time':
        return '휴식 끝';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('출첵봇'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '출첵봇에게 여러분의 출근/퇴근/휴식시간을 알려주세요!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(logs[index]['time']!),
                  trailing: Text(logs[index]['type']!),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _recordAttendance('check_in_time'),
                  child: const Text('출근'),
                ),
                ElevatedButton(
                  onPressed: () => _recordAttendance('check_out_time'),
                  child: const Text('퇴근'),
                ),
                ElevatedButton(
                  onPressed: () => _recordAttendance('break_start_time'),
                  child: const Text('휴식 시작'),
                ),
                ElevatedButton(
                  onPressed: () => _recordAttendance('break_end_time'),
                  child: const Text('휴식 끝'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
