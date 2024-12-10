import 'package:flutter/material.dart';
import 'package:tododata/controller/category_controller.dart';
import 'package:tododata/view/home_screen/home_screen.dart';

Future<void> main()   async {
WidgetsFlutterBinding.ensureInitialized();
await CategoryController.initializeDataBase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}