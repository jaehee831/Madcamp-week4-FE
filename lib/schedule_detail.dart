import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleDetail extends StatelessWidget {
  final String taskName;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> users;
  final String description;

  const ScheduleDetail({
    super.key,
    required this.taskName,
    required this.startTime,
    required this.endTime,
    required this.users,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat timeFormat = DateFormat.Hm();

    return Scaffold(
      appBar: AppBar(
        title: Text(taskName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              children: users.map((user) => Chip(label: Text(user))).toList(),
            ),
            const SizedBox(height: 24.0),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              '${timeFormat.format(startTime)} ~ ${timeFormat.format(endTime)}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

