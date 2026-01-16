import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reports_app/screens/incidents_screen.dart';
import 'package:reports_app/screens/login_screen.dart';
import 'package:reports_app/services/incidents_service.dart';
import 'package:reports_app/services/user_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => IncidentsService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reports App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(),
      routes: {
        '/incidents': (ctx) => const IncidentsScreen(),
        // '/create-incident': (ctx) => const CreateIncidentScreen(),
      },
    );
  }
}
