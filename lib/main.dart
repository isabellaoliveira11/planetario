import 'package:flutter/material.dart';
import 'package:planetario/views/home_page.dart';
import 'package:planetario/sqflite_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqfliteFactory.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planetário',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(79, 17, 112, 1.0), // Cor #4F1170
          titleTextStyle: TextStyle(
            color: Colors.white, // Cor do título (branco para contraste)
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardColor: const Color.fromRGBO(30, 30, 30, 0.7), // Cor para os cards
      ),
      home: const HomePage(),
    );
  }
}