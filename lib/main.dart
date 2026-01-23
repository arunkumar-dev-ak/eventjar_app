import 'package:country_code_picker/country_code_picker.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/notification_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/routes/route_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Global.onInit();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: [const Locale('en'), const Locale('lt')],
      localizationsDelegates: [CountryLocalizations.delegate],
      debugShowCheckedModeBanner: false,
      title: 'EventJar',
      theme: _buildLightTheme(context),
      themeMode: ThemeMode.system,
      initialRoute: RouteName.splashScreen,
      getPages: RoutePage().getPage,
    );
  }

  //light theme
  ThemeData _buildLightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        // Primary colors (1C56BF - blue)
        primary: const Color(0xFF1C56BF),
        onPrimary: Colors.white,
        // Secondary colors (167B4D - green)
        secondary: const Color(0xFF167B4D),
        onSecondary: Colors.white,

        tertiary: const Color(0xFF789ADE),
        onTertiary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black87,
        error: Colors.red.shade700,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  //dark theme
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: const Color(0xFF1C56BF),
        onPrimary: Colors.white,
        secondary: const Color(0xFF167B4D),
        onSecondary: Colors.white,
        tertiary: const Color(0xFF789ADE),
        onTertiary: Colors.white,
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white,
        error: Colors.red.shade400,
        onError: Colors.black,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
        bodyMedium: GoogleFonts.roboto(fontSize: 14, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
