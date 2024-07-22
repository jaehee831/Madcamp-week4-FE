// task 추가하는 flutter 코드
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AdminSchedule extends StatefulWidget {
  const AdminSchedule({super.key});

  @override
  _AdminScheduleState createState() => _AdminScheduleState();
}

class _AdminScheduleState extends State<AdminSchedule> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? startTime;
  DateTime? endTime;
  List<int> selectedUsers = [];
  List<DateTime> timeOptions =
      List.generate(24, (index) => DateTime.now().add(Duration(hours: index)));
  final DateFormat dateFormat = DateFormat('MM/dd HH:mm'); // 원하는 형식

  // Function to get users from the server
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3001/api/users'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Function to submit the task to the server
  void submitTask() async {
    if (_formKey.currentState!.validate()) {
      final taskData = {
        'task_name': taskNameController.text,
        'description': descriptionController.text,
        'start_time': startTime?.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'users': selectedUsers,
      };

      print('Sending task data to server: $taskData'); // 요청 데이터 로그

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/api/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(taskData),
      );

      print(
          'Server response: ${response.statusCode} - ${response.body}'); // 서버 응답 로그

      if (response.statusCode == 200) {
        // Task added successfully
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task added successfully')));
      } else {
        // Error adding task
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to add task')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading users'));
          } else {
            final users = snapshot.data!;
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    TextFormField(
                      controller: taskNameController,
                      decoration: const InputDecoration(labelText: 'Task Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter task name' : null,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter description' : null,
                    ),
                    DropdownButtonFormField<DateTime>(
                      decoration:
                          const InputDecoration(labelText: 'Start Time'),
                      value: startTime,
                      items: timeOptions.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(dateFormat.format(time)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          startTime = value;
                        });
                      },
                    ),
                    DropdownButtonFormField<DateTime>(
                      decoration: const InputDecoration(labelText: 'End Time'),
                      value: endTime,
                      items: timeOptions.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(dateFormat.format(time)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          endTime = value;
                        });
                      },
                    ),
                    const Text('Assign Users'),
                    Wrap(
                      children: users.map((user) {
                        return CheckboxListTile(
                          title: Text(user['name']),
                          value: selectedUsers.contains(user['iduser']),
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedUsers.add(user['iduser']);
                              } else {
                                selectedUsers.remove(user['iduser']);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: submitTask,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}