import 'package:flutter/material.dart';
import '../models/book.dart';
import 'package:intl/intl.dart';

class AddPage extends StatefulWidget {
  final Function(Book) addBook;
  const AddPage({super.key, required this.addBook});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _scoreController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;
  final List<String> _categories = [
    'Fiction',
    'Non-fiction',
    'Sci-Fi',
    'Biography'
  ];

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      widget.addBook(Book(
        title: _titleController.text,
        author: _authorController.text,
        score: int.parse(_scoreController.text),
        date: _selectedDate!,
        category: _selectedCategory!,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  filled: true,
                  fillColor: Colors.brown[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Author',
                  filled: true,
                  fillColor: Colors.brown[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Enter an author' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _scoreController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  filled: true,
                  fillColor: Colors.brown[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a Price';
                  if (int.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Pick a Date'
                    : 'Date: ${DateFormat.yMMMd().format(_selectedDate!)}'),
                trailing: const Icon(Icons.calendar_today, color: Colors.brown),
                onTap: _pickDate,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text('Select Category'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _validateAndSubmit,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Text('Add Book',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
