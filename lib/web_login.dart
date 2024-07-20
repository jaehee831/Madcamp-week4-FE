import 'dart:js' as js;

Future<void> loginWithKakao({Function(String, String)? onProfileFetched}) async {
  js.context.callMethod('loginWithKakao', [js.allowInterop((String profileImageUrl, String nickname) {
    if (onProfileFetched != null) {
      onProfileFetched(profileImageUrl, nickname);
    }
  })]);
}

Future<void> fetchProfile(Function(String, String)? onProfileFetched) async {
  js.context.callMethod('getProfile', [js.allowInterop((profileImageUrl, nickname) {
    if (onProfileFetched != null) {
      onProfileFetched(profileImageUrl, nickname);
    }
  })]);
}
