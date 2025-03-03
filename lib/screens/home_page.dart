import 'package:flutter/material.dart';
import '../models/book.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final List<Book> books;
  final Function(Book) addBook;
  final Function(int) removeBook;

  const HomePage({
    super.key,
    required this.books,
    required this.addBook,
    required this.removeBook,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;
  String? selectedAuthor;
  final String entityName = "Book";

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
              widget.removeBook(index);
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
    List<Book> filteredBooks = widget.books.where((book) {
      bool matchesCategory =
          selectedCategory == null || book.category == selectedCategory;
      bool matchesAuthor =
          selectedAuthor == null || book.author == selectedAuthor;
      return matchesCategory && matchesAuthor;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(entityName)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Welcome to $entityName! Browse and manage your favorite books.",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        hint: const Text('Filter by Category'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.brown),
                          ),
                        ),
                        items: widget.books
                            .map((book) => book.category)
                            .toSet()
                            .map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedAuthor,
                        hint: const Text('Filter by Author'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.brown),
                          ),
                        ),
                        items: widget.books
                            .map((book) => book.author)
                            .toSet()
                            .map((author) {
                          return DropdownMenuItem(
                            value: author,
                            child: Text(author),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedAuthor = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredBooks.isEmpty
                ? const Center(
                    child: Text('No books found',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown)))
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(filteredBooks[index].title),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          confirmDelete(context, index);
                          return false;
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 30),
                        ),
                        child: Card(
                          color: Colors.brown[100],
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(filteredBooks[index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown)),
                            subtitle: Text(
                              'Author: ${filteredBooks[index].author}\nCategory: ${filteredBooks[index].category}\nDate: ${DateFormat.yMMMd().format(filteredBooks[index].date)}',
                              style: const TextStyle(color: Colors.brown),
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
