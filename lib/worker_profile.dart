import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/member.dart';
import 'package:madcamp_week4_front/attendance_bot.dart';
import 'package:madcamp_week4_front/signup/mobile_logout.dart';

class WorkerProfile extends StatefulWidget {
  final int userId;

  const WorkerProfile({
    super.key,
    required this.userId
  });

  @override
  _WorkerProfileState createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
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
              logoutFromKakao(
                onLogoutSuccess: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/'); // 로그아웃 성공 시 메인화면으로 이동
                },
                onLogoutFailed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('로그아웃 실패'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('이름', style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  Text('이메일/전화번호', style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  Text('등록가게', style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  Text('계좌번호', style: TextStyle(fontSize: 16.0))
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceBotPage(userId: widget.userId),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

}
