import 'package:flutter/material.dart';
import 'package:groceries_app/screen/groceries_list.dart';


void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 129, 255, 255),
          surface: const Color.fromARGB(255, 42, 51, 59),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
      ),
      home: GroceriesList(),
    ),
  );
}