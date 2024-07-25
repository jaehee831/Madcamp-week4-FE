import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:madcamp_week4_front/main.dart';
import 'dart:convert';
import 'package:madcamp_week4_front/worker_profile.dart';
import 'package:madcamp_week4_front/admin/admin_profile.dart';

class Member extends StatefulWidget {
  final int userId;
  final int storeId;

  const Member({
    super.key,
    required this.userId,
    required this.storeId,
  });

  @override
  _MemberState createState() => _MemberState();
}

class _MemberState extends State<Member> {
  List<Map<String, dynamic>> members = [];

  @override
  void initState() {
    super.initState();
    _fetchMembers(widget.storeId);
  }

  Future<void> _fetchMembers(int storeId) async {
    final url = Uri.parse('http://143.248.191.63:3001/get_store_members');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'store_id': storeId}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        members = List<Map<String, dynamic>>.from(responseBody);
      });
    } else {
      throw Exception(
          'Failed to load store members. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멤버'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              _onPersonPressed(widget.userId);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/cake.png'),
            const SizedBox(height: 16.0),
            const Text(
              '멤버',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return ListTile(title: Text(member['name']));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPersonPressed(int userId) async {
    bool isAdmin = await _checkIsAdmin(userId);
    if (isAdmin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminProfile(userId: userId)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkerProfile(userId: userId)),
      );
    }
  }

  Future<bool> _checkIsAdmin(int userId) async {
    final url = Uri.parse('http://143.248.191.63:3001/check_isadmin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) == 1;
    } else {
      throw Exception(
          'Failed to check if user is admin. Status code: ${response.statusCode}');
    }
  }
}
