import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:madcamp_week4_front/main.dart';

class AdminAttendanceDetail extends StatelessWidget {
  final int userId;
  final String userName;

  const AdminAttendanceDetail({
    super.key,
    required this.userId,
    required this.userName,
  });

  Future<List<Map<String, dynamic>>> _fetchWorkDetails(int userId) async {
    final url = Uri.parse(
        'http://143.248.191.63:3001/get_member_work_time?user_id=$userId');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final records = responseBody['records'];
      return List<Map<String, dynamic>>.from(records);
    } else if (responseBody.containsKey('message') &&
        responseBody['message'] ==
            'No records found for the specified user_id') {
      return [];
    } else {
      throw Exception(
          'Failed to load work time. Status code: ${response.statusCode}');
    }
  }

  Future<String> _fetchTotalHours(int userId) async {
    final url = Uri.parse(
        'http://143.248.191.63:3001/get_member_work_time?user_id=$userId');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
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
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      return '$hours시간 $minutes분';
    } else if (responseBody.containsKey('message') &&
        responseBody['message'] ==
            'No records found for the specified user_id') {
      return '0시간 0분';
    } else {
      throw Exception(
          'Failed to load total hours. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userName 출석부'),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<String>(
        future: _fetchTotalHours(userId),
        builder: (context, totalHoursSnapshot) {
          if (totalHoursSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (totalHoursSnapshot.hasError) {
            return Center(child: Text('오류 발생: ${totalHoursSnapshot.error}'));
          } else {
            final totalHours = totalHoursSnapshot.data ?? '0시간 0분';
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                            userName,
                            style: const TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        totalHours,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchWorkDetails(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('오류 발생: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('근무 기록이 없습니다.'));
                      } else {
                        final workDetails = snapshot.data!;
                        return ListView(
                          children: workDetails.map((detail) {
                            DateTime checkIn =
                                DateTime.parse(detail['check_in_time']);
                            DateTime checkOut =
                                DateTime.parse(detail['check_out_time']);
                            DateTime breakStart =
                                DateTime.parse(detail['break_start_time']);
                            DateTime breakEnd =
                                DateTime.parse(detail['break_end_time']);
                            String formattedDate =
                                "${checkIn.month}/${checkIn.day}";
                            String checkInTime =
                                "${checkIn.hour}:${checkIn.minute.toString().padLeft(2, '0')}";
                            String checkOutTime =
                                "${checkOut.hour}:${checkOut.minute.toString().padLeft(2, '0')}";
                            String breakDuration =
                                "${breakEnd.difference(breakStart).inHours}시간 ${breakEnd.difference(breakStart).inMinutes % 60}분";

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(formattedDate,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child:
                                      Text("출근 $checkInTime  퇴근 $checkOutTime"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text("휴식 $breakDuration"),
                                ),
                                const Divider(),
                              ],
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
