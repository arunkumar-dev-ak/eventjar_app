import 'package:country_code_picker/country_code_picker.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/global/store/theme_store.dart';
import 'package:eventjar/notification/notification_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/routes/route_page.dart';
import 'package:eventjar/services/nfc_intent_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:clarity_flutter/clarity_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Global.onInit();
  await NotificationService().init();
  // final config = ClarityConfig(
  //   projectId: "v6b088h0dw",
  //   logLevel: LogLevel.Verbose,
  // );
  // runApp(ClarityWidget(app: MyApp(), clarityConfig: config));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize NFC intent handler after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NfcIntentHandler().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: [const Locale('en'), const Locale('lt')],
      localizationsDelegates: [CountryLocalizations.delegate],
      debugShowCheckedModeBanner: false,
      title: 'EventJar',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeStore.to.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: RouteName.splashScreen,
      getPages: RoutePage().getPage,
    );
  }

  //light theme
  ThemeData _buildLightTheme() {
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
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData(brightness: Brightness.light).textTheme,
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

  //dark theme
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: const Color(0xFF5B8DEF),
        onPrimary: Colors.white,
        secondary: const Color(0xFF2ECC71),
        onSecondary: Colors.white,
        tertiary: const Color(0xFF789ADE),
        onTertiary: Colors.white,
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white,
        surfaceContainerHighest: const Color(0xFF2C2C2C),
        error: Colors.red.shade400,
        onError: Colors.black,
      ),
      cardColor: const Color(0xFF1E1E1E),
      dividerColor: Colors.grey.shade800,
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        hintStyle: TextStyle(color: Colors.grey.shade500),
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5B8DEF), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2.0),
        ),
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
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFF1E1E1E),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
    );
  }
}
