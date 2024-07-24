import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:madcamp_week4_front/signup/signup_role_select.dart';
import 'conditional_import.dart';
import 'package:mysql_client/mysql_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter binding 초기화

  try {
    await dbConnector().timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("MySQL 연결 시간 초과");
    });
  } catch (e) {
    print("MySQL 연결에 실패했습니다: $e");
  }
  KakaoSdk.init(
      nativeAppKey: '539252187b3fd001076f5542826102de'); // Kakao SDK 초기화
  runApp(const MyApp());
}

Future<void> dbConnector() async {
  print("Connecting to mysql server...");

  try {
    // MySQL 접속 설정
    final conn = await MySQLConnection.createConnection(
      host: '143.248.191.173',
      port: 3306,
      userName: 'root',
      password: 'wogml0913!',
      databaseName: 'mydb', // optional
    );

    // 연결 대기
    await conn.connect();
    print("Connected");

    // 종료 대기
    await conn.close();
  } catch (e) {
    print("MySQL 연결 중 오류 발생: $e");
    rethrow; // 오류를 다시 던져서 main에서 처리할 수 있도록 함
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _userId = 0;
  String _nickname = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_userId != 0) Text('id: $_userId'),
            if (_nickname.isNotEmpty) Text('Hello, $_nickname!'),
            ElevatedButton(
              onPressed: () async {
                await loginWithKakao(onProfileFetched: (userId, nickname) {
                  setState(() {
                    _userId = userId;
                    _nickname = nickname;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpRoleSelect(
                        userId: _userId,
                        nickname: _nickname,
                      ),
                    ),
                  );
                });
              },
              child: const Text('카카오 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
