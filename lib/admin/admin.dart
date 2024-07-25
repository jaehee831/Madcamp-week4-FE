import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/main.dart';
import 'admin_attendance.dart';
import 'admin_money.dart';
import 'admin_notice.dart';
import 'admin_schedule.dart';
import 'package:madcamp_week4_front/signup/mobile_logout.dart';

class Admin extends StatelessWidget {
  final int userId;

  const Admin({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관리자 페이지'),
        backgroundColor: primaryColor,
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
                  Navigator.pushReplacementNamed(
                      context, '/'); // 로그아웃 성공 시 메인화면으로 이동
                },
                onLogoutFailed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('시간표 수정'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              scheduleChooseStore(userId: userId)),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('출석부'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              attendanceChooseStore(userId: userId)),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('공지 작성'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              noticeChooseStore(userId: userId)),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('급여 조회'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              moneyChooseStore(userId: userId)),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0), // 하단 패딩 추가
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/soup.png'),
                const SizedBox(height: 16),
                const Text('관리자 페이지입니다'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
