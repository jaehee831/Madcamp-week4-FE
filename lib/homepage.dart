import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/admin/admin_profile.dart';
import 'salary_details_page.dart'; // Import the new screen

class HomePage extends StatelessWidget {
  final int userId;

  const HomePage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('롯데리아 어은점'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminProfile(userId: userId)),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: const Text(
                '채널 변경',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.announcement),
              title: const Text('공지방'),
              onTap: () {
                // 공지방 클릭 시 동작 추가
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('인수인계방'),
              onTap: () {
                // 인수인계방 클릭 시 동작 추가
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('잡담방'),
              onTap: () {
                // 잡담방 클릭 시 동작 추가
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('대타구하기방'),
              onTap: () {
                // 대타구하기방 클릭 시 동작 추가
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('방 추가하기'),
              onTap: () {
                // 방 추가하기 클릭 시 동작 추가
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
              onTap: () {
                // 로그아웃 클릭 시 동작 추가
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 공지 섹션
            const Text(
              '공지',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                '7/20 사정일 사정으로 휴무합니다',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),
            // 업무 시간표 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '업무 시간표',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextButton(
                  onPressed: () {
                    // 더보기 버튼 동작 추가
                  },
                  child: const Text('더보기'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                '여기는 시간표~~',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),
            // 급여 계산 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '급여 계산',
                  style: TextStyle(fontSize: 16.0),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SalaryDetailsPage()), // Navigate to the new screen
                    );
                  },
                  child: const Text('더보기'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                '여기는 급여~~',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
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
