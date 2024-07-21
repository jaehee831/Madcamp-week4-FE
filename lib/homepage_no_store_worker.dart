import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/homepage.dart';
import 'package:madcamp_week4_front/worker_profile.dart';

class HomepageNoStoreWorker extends StatelessWidget {
  final int userId;

  const HomepageNoStoreWorker({
    super.key,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkerProfile()),
                );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('등록된 채널이 없어요'),
            SizedBox(height: 10),
            Text('채널을 등록해 주세요'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChannelAdd(userId: userId),
                  ),
                );
              },
              child: Text('채널 추가하기'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
      ),
    );
  }
}


class ChannelAdd extends StatefulWidget {
  final int userId;

  const ChannelAdd({
    super.key,
    required this.userId,
  });

  @override
  _ChannelAddState createState() => _ChannelAddState();
}

class _ChannelAddState extends State<ChannelAdd> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채널 추가하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('채널 비밀번호를 입력하세요'),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '비밀번호',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSubmit,
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    String password = _passwordController.text;
    // 여기서 서버로 비밀번호를 보내고 확인할 수 있습니다.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(), // HomePage로 이동
      ),
    );
  }

}
