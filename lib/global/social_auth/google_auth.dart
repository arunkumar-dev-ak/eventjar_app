import 'dart:io';

import 'package:eventjar/api/sign_up_api/sign_up_api.dart';
import 'package:eventjar/global/config/google_key_config.dart';
import 'package:eventjar/logger_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize(
        serverClientId: GoogleKeyConfig.webClientId,
        clientId: Platform.isIOS ? GoogleKeyConfig.iosClientId : null,
      );

      // 2. Trigger Sign In
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser != null) {
        final String? idToken = googleUser.authentication.idToken;
        LoggerService.loggerInstance.dynamic_d("idToken is ${idToken}");
        if (idToken != null) {
          LoggerService.loggerInstance.d("Token: $idToken");
          await SignUpApi.googleSignIn(idToken);
        }
      }
    } catch (e) {
      LoggerService.loggerInstance.e("Google Sign In Error: $e");
    }

    // try {
    //   final String idToken =
    //       "eyJhbGciOiJSUzI1NiIsImtpZCI6ImM0MWYxNDFhYTE5ZGYwYWM5N2RhYTU1ZTYwMDc2NmM0YzUzNjRjNDIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIzMDE2MDQxOTcyOTMtNHEwNmdtZGlzNDBnZXZtazhjNjhpbDhkMm1qM2g0NmUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIzMDE2MDQxOTcyOTMtcmwxNTlkdGxwbjkzdGh2MTZuc2wzM2U2Y3FxYXJ1dTYuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDczNTkzMjkyNTgzNjcxMzcyNjMiLCJlbWFpbCI6ImFydW5rdW1hcnAyMzA2MjAwM0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6IkFSVU5LVU1BUiBQIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FDZzhvY0xhdnlsTGc4d0lZYnNjZG9TV3UtaFVfeldmOFc5MjM1MU8xVmw4NFFiaXhnSC16dz1zOTYtYyIsImdpdmVuX25hbWUiOiJBUlVOS1VNQVIiLCJmYW1pbHlfbmFtZSI6IlAiLCJpYXQiOjE3NzQzMzE5MTYsImV4cCI6MTc3NDMzNTUxNn0.T63DHrLcm1rKmy4HFiRmFbBfN56poxmmVoYaupFrqB8KHC3kRLJz5O8fK36b3PyNL6pDNlAtTodHQBHanTVDq2lkTy77lPSBhhJMx1Ed4a6gCNGP2f3LUJjlamuiptPhSvqfJuCT5VXTNmZyQU7ih-M75-43IlfZAtATa6TOSKU1XDT_id6S4nFVuJa4Ct1fVR8zhhN4R7c1O1A17KPHa2DPneVXaRgEh64BSw1atSczDYyA";
    //   await SignUpApi.googleSignIn(idToken);
    // } catch (e) {
    //   LoggerService.loggerInstance.e("Google Sign In Error: $e");
    // }
  }
}
