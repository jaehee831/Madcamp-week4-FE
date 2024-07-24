import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final String postTitle;
  final String postContent;
  final String author;
  final String timestamp;
  final int likes;
  final int comments;

  const PostDetailPage({
    super.key,
    required this.postTitle,
    required this.postContent,
    required this.author,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('롯데리아 어은점'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postTitle,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              postContent,
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.favorite, size: 16.0, color: Colors.grey),
                const SizedBox(width: 4.0),
                Text('$likes'),
                const SizedBox(width: 16.0),
                Icon(Icons.comment, size: 16.0, color: Colors.grey),
                const SizedBox(width: 4.0),
                Text('$comments'),
              ],
            ),
            const SizedBox(height: 16.0),
            Divider(),
            Text(
              author,
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(
              timestamp,
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('이알바'),
                    subtitle: Text('저요저요'),
                    trailing: Text('57분 전'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      title: Text('이알바'),
                      subtitle: Text('오 굿굿'),
                      trailing: Text('57분 전'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
