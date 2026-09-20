import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  await StorageService().init();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Dark status bar icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF111827),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const TanishkAiBot());
}

class TanishkAiBot extends StatelessWidget {
  const TanishkAiBot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tanishk's AI Bot",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0F1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF22C55E),
          tertiary: Color(0xFFA855F7),
          surface: Color(0xFF111827),
          onSurface: Color(0xFFF1F5F9),
          outline: Color(0xFF1E2D45),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111827),
          foregroundColor: Color(0xFFF1F5F9),
          elevation: 0,
          centerTitle: false,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF111827),
          selectedItemColor: Color(0xFF3B82F6),
          unselectedItemColor: Color(0xFF475569),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1A2235),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF1E2D45),
          thickness: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF111827),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1E2D45)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1E2D45)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
          ),
          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
          hintStyle: const TextStyle(color: Color(0xFF475569)),
        ),
      ),
      builder: (context, child) {
        return Container(
          color: const Color(0xFF030712),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}
