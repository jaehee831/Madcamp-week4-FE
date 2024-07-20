import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'conditional_import.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '539252187b3fd001076f5542826102de'); // Kakao SDK 초기화
  runApp(const MyApp());
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
  String _profileImageUrl = '';
  String _nickname = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_profileImageUrl.isNotEmpty) 
              Image.network(_profileImageUrl, width: 100, height: 100),
            if (_nickname.isNotEmpty) 
              Text('Hello, $_nickname!'),
            ElevatedButton(
              onPressed: () async {
                await loginWithKakao(onProfileFetched: (profileImageUrl, nickname) {
                  setState(() {
                    _profileImageUrl = profileImageUrl;
                    _nickname = nickname;
                  });
                });
              },
              child: Text('카카오 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
