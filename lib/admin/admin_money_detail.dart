import 'package:flutter/material.dart';

class MoneyDetail extends StatelessWidget {
  final String name;
  final int totalMinutes;
  final int salary;

  const MoneyDetail({
    super.key,
    required this.name,
    required this.totalMinutes,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('급여 조회'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[200],
              child: const Icon(
                Icons.person,
                color: Colors.grey,
                size: 40,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '근무 시간',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              '$hours시간 $minutes분',
              style: const TextStyle(fontSize: 24, color: Colors.blue),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '이번 달 총 급여',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              '${salary.toString().replaceAllMapped(reg, (match) => '${match[0]},')}원',
              style: const TextStyle(fontSize: 24, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
