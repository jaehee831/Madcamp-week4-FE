import 'dart:js' as js;

Future<void> loginWithKakao({Function(int, String)? onProfileFetched}) async {
  js.context.callMethod('loginWithKakao', [js.allowInterop((int userId, String nickname) {
    if (onProfileFetched != null) {
      onProfileFetched(userId, nickname);
    }
  })]);
}

Future<void> fetchProfile(Function(int, String)? onProfileFetched) async {
  js.context.callMethod('getProfile', [js.allowInterop((userId, nickname) {
    if (onProfileFetched != null) {
      onProfileFetched(userId, nickname);
    }
  })]);
}
