import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/main.dart';
import 'post_detail_page.dart'; // Import the new post detail page
import 'write_post_page.dart';

class ChannelBoardPage extends StatelessWidget {
  final String channelName;

  const ChannelBoardPage({super.key, required this.channelName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(channelName),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Text(
                channelName,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const Text(
                '대타 구하는 채널입니다~',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              const SizedBox(height: 24.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostDetailPage(
                        postTitle: '7/19 월요일 오후 4시~7시 대타 구해요!',
                        postContent: '저는 화요일 같은 타임 가능합니다.',
                        author: '승락함',
                        timestamp: '57분 전',
                        likes: 4,
                        comments: 4,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '7/19 월요일 오후 4시~7시 대타 구해요!',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '저는 화요일 같은 타임 가능합니다.',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.favorite, size: 16.0, color: Colors.grey),
                          SizedBox(width: 4.0),
                          Text('4'),
                          SizedBox(width: 16.0),
                          Icon(Icons.comment, size: 16.0, color: Colors.grey),
                          SizedBox(width: 4.0),
                          Text('4'),
                          SizedBox(width: 16.0),
                          Text('승락함'),
                          SizedBox(width: 16.0),
                          Text('57분 전'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // 다른 게시글들을 위한 더미 컨테이너들
              GestureDetector(
                onTap: () {
                  // 다른 더미 게시글들을 누르면 동작할 코드
                },
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  color: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  // 다른 더미 게시글들을 누르면 동작할 코드
                },
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  color: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  // 다른 더미 게시글들을 누르면 동작할 코드
                },
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  color: Colors.grey[200],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WritePostPage(channelName: channelName),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor, // 버튼 색상을 #FFE174로 설정
            ),
            child: const Text('글쓰기',
                style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
