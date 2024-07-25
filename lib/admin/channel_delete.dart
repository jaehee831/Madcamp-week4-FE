import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/main.dart';
import 'package:madcamp_week4_front/signup/mobile_logout.dart';

class ChannelDelete extends StatelessWidget {
  const ChannelDelete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채널삭제'),
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            Text(
              '한 번 삭제한 채널은 되돌릴 수 없어요.\n조심해 주세요!',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            // 채널 목록
            ChannelCard(channelName: '롯데리아 어은점'),
            SizedBox(height: 16.0),
            ChannelCard(channelName: '미스터피자 어은점'),
          ],
        ),
      ),
    );
  }
}

class ChannelCard extends StatelessWidget {
  final String channelName;

  const ChannelCard({super.key, required this.channelName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0BA), // primaryColor를 배경색으로 설정
        borderRadius: BorderRadius.circular(20.0), // borderRadius를 20으로 설정
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
