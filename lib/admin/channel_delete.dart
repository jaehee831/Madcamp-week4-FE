import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/signup/mobile_logout.dart';

class ChannelDelete extends StatelessWidget {
  const ChannelDelete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채널삭제'),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              '한 번 삭제한 채널은 되돌릴 수 없어요.\n조심해 주세요!',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // 채널 목록
            ChannelCard(channelName: '롯데리아 어은점'),
            const SizedBox(height: 16.0),
            ChannelCard(channelName: '미스터피자 어은점'),
          ],
        ),
      ),
    );
  }
}

class ChannelCard extends StatelessWidget {
  final String channelName;

  const ChannelCard({required this.channelName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            channelName,
            style: const TextStyle(fontSize: 16.0),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // 채널 삭제 동작 추가
            },
          ),
        ],
      ),
    );
  }
}
