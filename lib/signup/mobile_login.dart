import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/services.dart';

Future<void> loginWithKakao({Function(int, String)? onProfileFetched}) async {
  try {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        await fetchProfile(onProfileFetched);
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          await fetchProfile(onProfileFetched);
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error'); 
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        await fetchProfile(onProfileFetched);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  } catch (error) {
    print('카카오 로그인 중 오류 발생 $error');
  }
}

Future<void> fetchProfile(Function(int, String)? onProfileFetched) async {
  try {
    User user = await UserApi.instance.me();
    int userId = user.id;
    String nickname = user.kakaoAccount?.profile?.nickname ?? '';
    if (onProfileFetched != null) {
      onProfileFetched(userId, nickname);
    }
    print('사용자 프로필 가져오기 성공');
  } catch (error) {
    print('사용자 프로필 가져오기 실패 $error');
  }
}