// main.dart
import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/add_page.dart';
import 'models/book.dart';

void main() {
  runApp(const BookApp());
}

class BookApp extends StatefulWidget {
  const BookApp({super.key});

  @override
  State<BookApp> createState() => _BookAppState();
}

class _BookAppState extends State<BookApp> {
  final List<Book> books = [];

  void addBook(Book book) {
    setState(() {
      books.add(book);
    });
  }

  void removeBook(int index) {
    setState(() {
      books.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.brown[50],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.brown),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown[100],
          foregroundColor: Colors.brown[800],
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.brown[300],
          foregroundColor: Colors.white,
        ),
      ),
      routes: {
        '/': (context) =>
            HomePage(books: books, addBook: addBook, removeBook: removeBook),
        '/add': (context) => AddPage(addBook: addBook),
      },
    );
  }
}
