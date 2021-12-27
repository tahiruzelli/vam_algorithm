import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vam_algorithm/views/enter_matrix_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vam Algorithm',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: EnterNumbersPage(),
    );
  }
}
