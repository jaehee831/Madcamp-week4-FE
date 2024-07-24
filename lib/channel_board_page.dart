import 'package:flutter/material.dart';
import 'post_detail_page.dart';
import 'write_post_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ChannelBoardPage extends StatefulWidget {
  final int userId;
  final String channelName;
  final int boardId;
  final String description;

  const ChannelBoardPage({
    super.key,
    required this.userId,
    required this.channelName,
    required this.boardId,
    required this.description
  });

  @override
  _ChannelBoardPageState createState() => _ChannelBoardPageState();
}

class _ChannelBoardPageState extends State<ChannelBoardPage> {
  List<Map<String, dynamic>> posts = [];
  Map<int, String> userNames = {};

  @override
  void initState() {
    super.initState();
    _fetchPosts(widget.boardId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channelName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.channelName,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.description,
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: posts.isEmpty
                  ? Center(
                      child: Text(
                        '게시판에 등록된 글이 없습니다',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        final userName = userNames[post['user_id']] ?? 'Loading...';
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final author = await _getUserName(post['user_id']);
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetailPage(
                                      userId: widget.userId,
                                      channelName: widget.channelName,
                                      boardId: widget.boardId,
                                      description: widget.description,
                                      postTitle: post['title'],
                                      postContent: post['content'],
                                      author: author,
                                      timestamp: formatTimestamp(post['time']),
                                      likes: post['like_count'],
                                      postId: post['idpost'],
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  setState(() {
                                    _fetchPosts(widget.boardId); // 데이터 새로 고침
                                  });
                                }
                              },
                              child: Container(
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
                                      post['title'],
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      post['content'],
                                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        Icon(Icons.favorite, size: 16.0, color: Colors.grey),
                                        const SizedBox(width: 4.0),
                                        Text('${post['like_count']}'),
                                        const SizedBox(width: 16.0),
                                        Text(userName),
                                        const SizedBox(width: 16.0),
                                        Text(formatTimestamp(post['time'])),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        );
                      },
                    ),
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
                  builder: (context) => WritePostPage(
                    userId: widget.userId,
                    channelName: widget.channelName,
                    boardId: widget.boardId,
                  ),
                ),
              );
            },
            child: Text('+ 글쓰기'),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchPosts(int boardId) async {
    final url = Uri.parse('http://143.248.191.173:3001/get_posts');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'board_id': boardId}),
    );
    print("get_posts: ${response.statusCode}");
    print("get_posts: ${response.body}");
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is Map && responseBody.containsKey('message') && responseBody['message'] == 'no post in the board') {
        setState(() {
          posts = [];
        });
      } else {
        final fetchedPosts = List<Map<String, dynamic>>.from(responseBody);
        final fetchedUserNames = await Future.wait(fetchedPosts.map((post) => _getUserName(post['user_id'])).toList());

        setState(() {
          posts = fetchedPosts;
          for (int i = 0; i < posts.length; i++) {
            userNames[posts[i]['user_id']] = fetchedUserNames[i];
          }
        });
      }
    } else {
      throw Exception('Failed to load posts');
    }
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('MM/dd HH:mm').format(dateTime);
  }

  Future<String> _getUserName(int userId) async {
    final url = Uri.parse('http://143.248.191.173:3001/get_user_name');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['user_name'];
    } else {
      throw Exception('Failed to load user name. Status code: ${response.statusCode}');
    }
  }
}
