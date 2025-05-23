import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/money.dart';
import '../models/money_storage.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      final suggested = _suggestCategory(_descriptionController.text);
      if (suggested != _selectedCategory) {
        setState(() {
          _selectedCategory = suggested;
        });
      }
    });
  }

  String _suggestCategory(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('burger') ||
        desc.contains('pizza') ||
        desc.contains('food')) {
      return 'Food';
    } else if (desc.contains('uber') ||
        desc.contains('taxi') ||
        desc.contains('fuel') ||
        desc.contains('bus')) {
      return 'Transport';
    } else if (desc.contains('shirt') ||
        desc.contains('shoes') ||
        desc.contains('clothes') ||
        desc.contains('shopping')) {
      return 'Shopping';
    } else if (desc.contains('rent') ||
        desc.contains('bill') ||
        desc.contains('electricity') ||
        desc.contains('water')) {
      return 'Bills';
    } else {
      return 'Other';
    }
  }

  void _submitExpense() {
    final amount = _amountController.text.trim();
    final description = _descriptionController.text.trim();

    if (amount.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final expense = Expense(
      amount: amount,
      description: description,
      category: _selectedCategory,
      date: _selectedDate,
    );

    ExpenseStorage.expenses.add(expense);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Money added successfully!')),
    );

    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFEECE2), Color(0xFFF8D2CB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Color(0xFFFE6B8B), Color(0xFFFF8E53)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    'Add New Money',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (PKR)',
                    labelStyle: const TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.attach_money,
                        color: Colors.pinkAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon:
                        const Icon(Icons.description, color: Colors.purple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: const TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon:
                        const Icon(Icons.category, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today,
                          color: Colors.deepPurple),
                      label: const Text("Pick Date"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _submitExpense,
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Add Expense',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                      shadowColor: Colors.pinkAccent.shade200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
