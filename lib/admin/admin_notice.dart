import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_week4_front/homepage.dart';
import 'package:madcamp_week4_front/main.dart';
import 'dart:convert';
import 'package:madcamp_week4_front/signup/mobile_logout.dart';

class noticeChooseStore extends StatefulWidget {
  final int userId;

  const noticeChooseStore({super.key, required this.userId});

  @override
  _noticeChooseStoreState createState() => _noticeChooseStoreState();
}

class _noticeChooseStoreState extends State<noticeChooseStore> {
  late Future<List<Map<String, dynamic>>> storeFuture;

  @override
  void initState() {
    super.initState();
    storeFuture = _fetchStores(widget.userId);
  }

  Future<List<Map<String, dynamic>>> _fetchStores(int userId) async {
    final storeListUrl = Uri.parse('http://143.248.191.63:3001/get_store_list');
    final storeNameUrl =
        Uri.parse('http://143.248.191.63:3001/get_store_name_list');

    final storeListResponse = await http.post(
      storeListUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId.toString()}),
    );

    if (storeListResponse.statusCode != 200) {
      throw Exception('Failed to load store ids');
    } else if (jsonDecode(storeListResponse.body).containsKey('message')) {
      throw Exception('No store registered');
    }

    final storeIds =
        List<int>.from(jsonDecode(storeListResponse.body)['storeIds']);
    final List<Map<String, dynamic>> stores = [];

    for (int storeId in storeIds) {
      final storeNameResponse = await http.post(
        storeNameUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'store_id': storeId.toString()}),
      );

      if (storeNameResponse.statusCode == 200) {
        final storeName = jsonDecode(storeNameResponse.body)['store_name'];
        stores.add({'store_id': storeId, 'store_name': storeName});
      }
    }

    return stores;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지 수정'),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: storeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('등록된 가게가 없습니다.'));
          } else {
            final stores = snapshot.data!;
            return ListView(
              children: stores.map((store) {
                return ListTile(
                  title: Text(store['store_name']),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminNotice(
                              storeId: store['store_id'],
                              userId: widget.userId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // 버튼 색상 설정
                    ),
                    child:
                        const Text('선택', style: TextStyle(color: Colors.black)),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

class AdminNotice extends StatefulWidget {
  final int storeId;
  final int userId;

  const AdminNotice({super.key, required this.storeId, required this.userId});

  @override
  _AdminNoticeState createState() => _AdminNoticeState();
}

class _AdminNoticeState extends State<AdminNotice> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    Future<void> updateNotice() async {
      final noticeText = controller.text;
      if (noticeText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('공지 내용을 입력하세요')),
        );
        return;
      }

      final url = Uri.parse('http://143.248.191.63:3001/edit_notice');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': noticeText,
          'time': DateTime.now().toIso8601String(),
          'idstores': 1,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('공지 등록 완료')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(userId: widget.userId, storeId: widget.storeId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('공지 등록 실패')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지 작성'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '공지 내용을 입력하세요:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '공지 내용을 입력하세요',
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: updateNotice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // 버튼 색상 설정
                ),
                child: const Text(
                  '공지 등록',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
