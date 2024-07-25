import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PostDetailPage extends StatefulWidget {
  final int userId;
  final String channelName;
  final int boardId;
  final String description;
  final String postTitle;
  final String postContent;
  final String author;
  final String timestamp;
  final int likes;
  final int postId;

  const PostDetailPage({
    super.key,
    required this.userId,
    required this.channelName,
    required this.boardId,
    required this.description,
    required this.postTitle,
    required this.postContent,
    required this.author,
    required this.timestamp,
    required this.likes,
    required this.postId,
  });

  @override
  _PostDetailPageState createState() {
    print('PostDetailPage createState 호출됨');
    return _PostDetailPageState();
  } 
}

class _PostDetailPageState extends State<PostDetailPage> {
  late int likeCount;
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
    // 모든 위젯 데이터 출력
    print('PostDetailPage 데이터:');
    print('userId: ${widget.userId}');
    print('channelName: ${widget.channelName}');
    print('boardId: ${widget.boardId}');
    print('description: ${widget.description}');
    print('postTitle: ${widget.postTitle}');
    print('postContent: ${widget.postContent}');
    print('author: ${widget.author}');
    print('timestamp: ${widget.timestamp}');
    print('likes: ${widget.likes}');
    print('postId: ${widget.postId}');
    _fetchComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.postTitle,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.postContent,
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite, size: 16.0, color: Colors.grey),
                  onPressed: _incrementLike,
                ),
                const SizedBox(width: 4.0),
                Text('$likeCount')
              ],
            ),
            const SizedBox(height: 16.0),
            Divider(),
            Text(
              widget.author,
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.timestamp,
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: comments.isEmpty
                  ? Center(child: Text('댓글이 없습니다.', style: TextStyle(fontSize: 16.0, color: Colors.grey)))
                  : ListView(
                      children: [
                        for (var comment in comments)
                          ListTile(
                            title: FutureBuilder<String>(
                              future: _getUserName(comment['user_id']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text('Loading...');
                                } else if (snapshot.hasError) {
                                  return Text('Error');
                                } else {
                                  return Text(snapshot.data ?? 'Unknown');
                                }
                              },
                            ),
                            subtitle: Text(comment['content'] ?? 'No content'),
                            trailing: Text(
                              comment['time'] != null
                                  ? DateFormat('MM/dd HH:mm').format(DateTime.parse(comment['time']))
                                  : 'No timestamp',
                            ),
                          ),
                      ],
                    ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _saveComment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateLikeCount() async {
    try {
      final url = Uri.parse('http://143.248.191.63:3001/edit_like_count');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idpost': widget.postId, 'like_count': likeCount}),
      );
      print("edit_like_count: ${response.body}");
      print("edit_like_count: ${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update like count')),
        );
      }
    } catch (e) {
      print("Error in _updateLikeCount: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좋아요 수를 업데이트하는 중 오류가 발생했습니다')),
      );
    }
  }

  void _incrementLike() {
    setState(() {
      likeCount += 1;
    });
    _updateLikeCount();
  }

  Future<void> _saveComment() async {
    try {
      final url = Uri.parse('http://143.248.191.63:3001/save_comment');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idpost': widget.postId,
          'content': _commentController.text,
          'parent_comment_id': 0,
          'user_id': widget.userId
        }),
      );

      print("save_comment: ${response.body}");
      print("save_comment: ${response.statusCode}");

      if (response.statusCode == 200) {
        setState(() {
          comments.add({
            'content': _commentController.text,
            'user_id': widget.userId,
            'time': DateTime.now().toString(),
          });
          _commentController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글이 성공적으로 추가되었습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글 추가 실패')),
        );
      }
    } catch (e) {
      print("Error in _saveComment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글을 저장하는 중 오류가 발생했습니다')),
      );
    }
  }

  Future<String> _getUserName(int userId) async {
    try {
      final url = Uri.parse('http://143.248.191.63:3001/get_user_name');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );
      print("get_user_name: ${response.body}");
      print("get_user_name: ${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['user_name'];
      } else {
        throw Exception('Failed to load user name. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in _getUserName: $e");
      return 'Unknown';
    }
  }

  Future<void> _fetchComments(int postId) async {
    try {
      print('fetchComments 호출됨, postId: $postId');
      final url = Uri.parse('http://143.248.191.63:3001/get_comments');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'post_id': postId}),
      );
      print("get_comments: ${response.body}");
      print("get_comments: ${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is Map && responseBody.containsKey('message') && responseBody['message'] == 'no comments found') {
          setState(() {
            comments = [];
          });
        } else {
          setState(() {
            comments = List<Map<String, dynamic>>.from(responseBody);
          });
        }
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      print("Error in _fetchComments: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글을 불러오는 중 오류가 발생했습니다')),
      );
    }
  }
}
