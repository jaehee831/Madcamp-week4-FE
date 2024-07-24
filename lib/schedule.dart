import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:madcamp_week4_front/admin/admin_profile.dart';
import 'package:madcamp_week4_front/main.dart';
import 'package:madcamp_week4_front/worker_profile.dart';
import 'package:madcamp_week4_front/schedule_detail.dart';

class Schedule extends StatefulWidget {
  final int userId;
  final int storeId;

  const Schedule({
    super.key,
    required this.userId,
    required this.storeId,
  });

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<Map<String, dynamic>> tasks = [];
  final DateFormat timeFormat = DateFormat.Hm();

  @override
  void initState() {
    super.initState();
    _fetchTasks(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시간표'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              _onPersonPressed(widget.userId);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              '시간표',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                      child: Text(
                        '가게에 배정된 task가 없습니다',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        final startTime = DateTime.parse(task['start_time']);
                        final endTime = DateTime.parse(task['end_time']);
                        return FutureBuilder<Map<String, dynamic>>(
                          future: _fetchTaskDetails(task['idtasks'] ?? 0),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScheduleDetail(
                                        taskName:
                                            task['task_name'] ?? 'Unknown task',
                                        startTime: startTime,
                                        endTime: endTime,
                                        users: const [],
                                        description: task['description'] ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task['task_name'] ?? 'Unknown task',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}',
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                      const SizedBox(height: 8.0),
                                      const Text(
                                        '담당자: 없음',
                                        style: TextStyle(
                                            fontSize: 14.0, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              final userNames =
                                  snapshot.data?['userNames'] ?? [];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScheduleDetail(
                                        taskName:
                                            task['task_name'] ?? 'Unknown task',
                                        startTime: startTime,
                                        endTime: endTime,
                                        users: userNames,
                                        description: task['description'] ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task['task_name'] ?? 'Unknown task',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}',
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '담당자: ${userNames.isEmpty ? '없음' : userNames.join(', ')}',
                                        style: const TextStyle(
                                            fontSize: 14.0, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
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

  Future<Map<String, dynamic>> _fetchTaskDetails(int taskId) async {
    final users = await _fetchUsersFromTask(taskId);
    final userNames = await Future.wait(
        users.map((userId) => _fetchUserName(userId)).toList());
    return {
      'userNames': userNames,
    };
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
        setState(() {
          tasks = List<Map<String, dynamic>>.from(responseBody);
        });
      } else if (responseBody is Map && responseBody.containsKey('message')) {
        print('no registered tasks in the store');
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception(
          'Failed to load tasks in the store. Status code: ${response.statusCode}');
    }
  }

  Future<List<int>> _fetchUsersFromTask(int taskId) async {
    if (taskId == 0) {
      return [];
    }
    final url = Uri.parse('http://143.248.191.173:3001/get_user_from_task');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'task_id': taskId}),
    );
    print('get_user_from_task: Response Body: ${response.body}');
    print('get_user_from_task: Response Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      return List<int>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to load users from task. Status code: ${response.statusCode}');
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
