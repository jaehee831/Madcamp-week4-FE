import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> logoutFromKakao({Function()? onLogoutSuccess, Function()? onLogoutFailed}) async {
  try {
    await UserApi.instance.logout();
    print('카카오 로그아웃 성공');
    if (onLogoutSuccess != null) {
      onLogoutSuccess();
    }
  } catch (error) {
    print('카카오 로그아웃 실패 $error');
    if (onLogoutFailed != null) {
      onLogoutFailed();
    }
  }
}
