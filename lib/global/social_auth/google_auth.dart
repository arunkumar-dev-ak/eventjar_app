import 'dart:io';

import 'package:eventjar/global/config/google_key_config.dart';
import 'package:eventjar/logger_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<void> signInWithGoogle({
    required Function(String idToken) onSuccess,
  }) async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize(
        serverClientId: GoogleKeyConfig.webClientId,
        clientId: Platform.isIOS ? GoogleKeyConfig.iosClientId : null,
      );

      // 2. Trigger Sign In
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final String? idToken = googleUser.authentication.idToken;
      LoggerService.loggerInstance.dynamic_d("idToken is $idToken");
      if (idToken != null) {
        LoggerService.loggerInstance.d("Token: $idToken");
        onSuccess(idToken);
      }
    } catch (e) {
      LoggerService.loggerInstance.e("Google Sign In Error: $e");
    }
  }
}
