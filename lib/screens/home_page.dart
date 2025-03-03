import 'package:flutter/material.dart';
import '../models/book.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final List<Book> books;
  final Function(Book) addBook;
  final Function(int) removeBook;

  const HomePage({
    super.key,
    required this.books,
    required this.addBook,
    required this.removeBook,
  });

  void confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.brown[50],
        title:
            const Text('Confirm Delete', style: TextStyle(color: Colors.brown)),
        content: const Text('Are you sure you want to delete this book?',
            style: TextStyle(color: Colors.brown)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.brown)),
          ),
          TextButton(
            onPressed: () {
              removeBook(index);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: books.isEmpty
          ? const Center(
              child: Text('No books added yet',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown)))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(books[index].title),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    confirmDelete(context, index);
                    return false;
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child:
                        const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  child: Card(
                    color: Colors.brown[100],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(books[index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown)),
                      subtitle: Text(
                        'Author: ${books[index].author}\nCategory: ${books[index].category}\nDate: ${DateFormat.yMMMd().format(books[index].date)}',
                        style: const TextStyle(color: Colors.brown),
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
