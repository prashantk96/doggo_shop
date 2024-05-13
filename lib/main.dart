import 'package:doggo_shop/screens/cart_screen.dart';
import 'package:doggo_shop/screens/history_screen.dart';
import 'package:doggo_shop/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

late Size mq;
void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo, foregroundColor: Colors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
          primaryColor: Colors.indigo,
          scaffoldBackgroundColor: Colors.indigo.shade50,
          appBarTheme: const AppBarTheme(color: Colors.indigo)),
      title: 'Doggo Shop',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
