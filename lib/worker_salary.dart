import 'package:flutter/material.dart';

// 직원용 급여 페이지

class WorkerSalary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('급여 계산'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '000님의 시급',
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '9,485 원',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // 시급 수정 동작 추가
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                '이달의 급여',
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                '총 372,444 원 쌓였어요',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '근무시간 총 17시간',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
