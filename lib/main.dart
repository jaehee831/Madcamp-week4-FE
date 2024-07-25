import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:madcamp_week4_front/signup/signup_role_select.dart';
import 'conditional_import.dart';
import 'package:mysql_client/mysql_client.dart';

const Color primaryColor = Color(0xFFFFE174);

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
      nativeAppKey: ''); // Kakao SDK 초기화
  runApp(const MyApp());
}

Future<void> dbConnector() async {
  print("Connecting to mysql server...");

  try {
    // MySQL 접속 설정
    final conn = await MySQLConnection.createConnection(
      host: '',
      port: ,
      userName: '',
      password: '',
      databaseName: '', // optional
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
          primaryColor: const Color(0xFFFFE174),
          primaryColorLight: const Color(0xFFFFE174),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'gsansmedium'),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(), // 메인 화면 라우트
      },
      debugShowCheckedModeBanner: false,
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
      body: Column(
        children: <Widget>[
          const Spacer(), // This will push the text and button to the center
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '반갑습니다!',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                    height: 100), // Adds space between the text and button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // 버튼 배경색 지정
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // border-radius 설정
                    ),
                    minimumSize: const Size(
                        200, 50), // 버튼 너비와 높이 설정 (width: 200, height: 50)
                  ),
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
          const Spacer(), // This will push the image to the bottom
          Padding(
            padding: const EdgeInsets.all(16.0), // 하단에 약간의 여백을 추가
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/logo_for_login.png',
                width: 185,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
