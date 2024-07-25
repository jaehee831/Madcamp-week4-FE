import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:madcamp_week4_front/channel_board_page.dart';
import 'package:madcamp_week4_front/main.dart';

class WritePostPage extends StatefulWidget {
  final int userId;
  final String channelName;
  final int boardId;

  const WritePostPage(
      {super.key,
      required this.userId,
      required this.channelName,
      required this.boardId});

  @override
  _WritePostPageState createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channelName),
        backgroundColor: primaryColor,
        actions: [
          TextButton(
            onPressed: _savePost,
            child: const Text(
              '완료',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                labelStyle: TextStyle(color: Colors.grey),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '내용을 입력하세요',
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePost() async {
    final url = Uri.parse('http://143.248.191.63:3001/create_posts');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': _titleController.text,
        'content': _contentController.text,
        'board_id': widget.boardId,
        'user_id': widget.userId
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post saved successfully')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChannelBoardPage(
              userId: widget.userId,
              channelName: widget.channelName,
              boardId: widget.boardId,
              description: 'df'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to save post')));
    }
  }
}
