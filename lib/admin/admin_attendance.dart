import 'package:flutter/material.dart';

class AdminAttendance extends StatelessWidget {
  const AdminAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('출석부'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 로그아웃 동작 추가
            },
          ),
        ],
      ),
      body: ListView(
        children: const [
          AttendanceListItem(
            name: '김알바',
            hours: '76시간',
          ),
          Divider(),
          AttendanceListItem(
            name: '김알바',
            hours: '70시간',
          ),
          Divider(),
          AttendanceListItem(
            name: '김알바',
            hours: '79시간',
          ),
          Divider(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

class AttendanceListItem extends StatelessWidget {
  final String name;
  final String hours;

  const AttendanceListItem({
    required this.name,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16.0),
              Text(
                name,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          Text(
            hours,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
