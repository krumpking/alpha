// import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:alpha/config/routes/routes.dart';
import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/features/welcome/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

Future<void> main() async {
  await _setup();
  runApp(const Alpha());
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
}

class Alpha extends StatelessWidget {
  const Alpha({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        dialogBackgroundColor: Colors.white, // Change dialog background color
        focusColor: primaryColor, // Change focus color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: accentColor,
          background: Colors.grey[200], // General background color
          surface: Colors.white, // Surface color for cards, etc.
          onPrimary: Colors.white, // Text color on primary color
          onSecondary: Colors.black, // Text color on secondary color
          onBackground: Colors.black, // Text color on background color
          onSurface: Colors.black, // Text color on surface color
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 18.0),
          displayMedium: TextStyle(fontSize: 18.0),
          displaySmall: TextStyle(fontSize: 18.0),
          headlineLarge: TextStyle(fontSize: 18.0),
          headlineMedium: TextStyle(fontSize: 18.0),
          headlineSmall: TextStyle(fontSize: 18.0),
          titleLarge: TextStyle(fontSize: 18.0),
          titleMedium: TextStyle(fontSize: 18.0),
          titleSmall: TextStyle(fontSize: 18.0),
          bodyLarge: TextStyle(fontSize: 18.0),
          bodyMedium: TextStyle(fontSize: 18.0),
          bodySmall: TextStyle(fontSize: 18.0),
          labelLarge: TextStyle(fontSize: 18.0),
          labelMedium: TextStyle(fontSize: 18.0),
          labelSmall: TextStyle(fontSize: 18.0),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white, // Dialog background color
          titleTextStyle: TextStyle(
              color: primaryColor, fontSize: 20), // Dialog title text style
          contentTextStyle: TextStyle(
              color: Colors.black, fontSize: 16), // Dialog content text style
        ),
      ),
      supportedLocales: const [
        Locale('en'), // English
        Locale('sh'), // Shona
        Locale('nbl') // Ndebele
      ],
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const SplashScreen(),
    );
  }
}
