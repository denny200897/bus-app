import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/providers/theme_provider.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/screens/home_screen.dart'; // 確保導入 HomeScreen 類別

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => NotesProvider()),
    ],
    child: const NotesApp(),
  ));
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: '筆記本應用',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.blueGrey,
          secondary: Colors.blueAccent,
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: const HomeScreen(), // HomeScreen 需要繼承 StatelessWidget 或 StatefulWidget
    );
  }
}
