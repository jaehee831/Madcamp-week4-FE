import 'package:flutter/material.dart';
import 'write_post_page.dart'; // Import the new write post page

class ChannelBoardPage extends StatelessWidget {
  final String channelName;

  const ChannelBoardPage({super.key, required this.channelName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(channelName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              channelName,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '대타 구하는 채널입니다~',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '7/19 월요일 오후 4시~7시 대타 구해요!',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '저는 화요일 같은 타임 가능합니다.',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 16.0, color: Colors.grey),
                      const SizedBox(width: 4.0),
                      Text('4'),
                      const SizedBox(width: 16.0),
                      Icon(Icons.comment, size: 16.0, color: Colors.grey),
                      const SizedBox(width: 4.0),
                      Text('4'),
                      const SizedBox(width: 16.0),
                      Text('승락함'),
                      const SizedBox(width: 16.0),
                      Text('57분 전'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // 다른 게시글들을 위한 더미 컨테이너들
            Container(
              width: double.infinity,
              height: 100.0,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 100.0,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 100.0,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
            child: Text('+ 글쓰기'),
          ),
        ),
      ),
    );
  }
}
