import 'package:flutter/material.dart';
import 'package:location_automobiles/viewmodel/ajout_automobile.dart';
import 'package:location_automobiles/viewmodel/automobile_viewmodel.dart';
import 'package:location_automobiles/viewmodel/compte_viewmodel.dart';
import 'package:location_automobiles/viewmodel/user_viewmodel.dart';
import 'package:location_automobiles/views/role_selection.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AutomobileViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ajouterAutomobileViewModel(),
        ),
        ChangeNotifierProxyProvider<UserViewModel, CompteViewModel>(
          create: (context) => CompteViewModel(
            userViewModel: Provider.of<UserViewModel>(context, listen: false),
          ),
          update: (context, userViewModel, previousCompteViewModel) =>
              CompteViewModel(userViewModel: userViewModel),
        ),
      ],
      child: const Location_vehicule(),
    ),
  );
}

class Location_vehicule extends StatelessWidget {
  const Location_vehicule({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LockNat',
      theme: ThemeData(
        primaryColor: const Color(0xFF0B132C),
        primarySwatch: _createMaterialColor(const Color(0xFF0B132C)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B132C),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 24.0,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0B132C),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          labelStyle: TextStyle(color: Color(0xFF0B132C)),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Color(0xFF0B132C)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Color(0xFF0B132C), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          prefixIconColor: Color(0xFF0B132C),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF0B132C)),
          bodyMedium: TextStyle(color: Color(0xFF0B132C)),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF0B132C),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: _createMaterialColor(const Color(0xFF0B132C)),
          backgroundColor: Colors.white,
          accentColor: const Color(0xFF0B132C),
        ).copyWith(secondary: const Color(0xFF0B132C)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoleSelectionPage(),
      },
    );
  }

  static MaterialColor _createMaterialColor(Color color) {
    return MaterialColor(color.value, <int, Color>{
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }
}