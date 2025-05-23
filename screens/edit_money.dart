import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/money.dart';

class EditExpenseScreen extends StatefulWidget {
  final int index;
  final Expense expense;

  const EditExpenseScreen(
      {super.key, required this.index, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  late DateTime _selectedDate;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.expense.amount);
    _descriptionController =
        TextEditingController(text: widget.expense.description);
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.date;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Theme the date picker to teal colors
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.teal.shade900,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal.shade700,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateExpense() {
    final amount = _amountController.text.trim();
    final description = _descriptionController.text.trim();

    if (amount.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final updatedExpense = Expense(
      amount: amount,
      description: description,
      category: _selectedCategory,
      date: _selectedDate,
    );

    Navigator.pop(context, updatedExpense); // Return updated expense
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Expense',
          style: GoogleFonts.poppins(
            color: Colors.teal.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.teal.shade800),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3FDFD), Color(0xFFCBF1F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Amount field
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                shadowColor: Colors.teal.shade200,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.teal.shade900),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Amount',
                      labelStyle:
                          GoogleFonts.poppins(color: Colors.teal.shade700),
                      prefixIcon:
                          Icon(Icons.attach_money, color: Colors.teal.shade700),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description field
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                shadowColor: Colors.teal.shade200,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: _descriptionController,
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.teal.shade900),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Description',
                      labelStyle:
                          GoogleFonts.poppins(color: Colors.teal.shade700),
                      prefixIcon:
                          Icon(Icons.description, color: Colors.teal.shade700),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Category dropdown inside a card
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                shadowColor: Colors.teal.shade200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    iconEnabledColor: Colors.teal.shade700,
                    items: _categories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category,
                                style: GoogleFonts.poppins(
                                    color: Colors.teal.shade900, fontSize: 16),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Category',
                      labelStyle:
                          GoogleFonts.poppins(color: Colors.teal.shade700),
                      prefixIcon:
                          Icon(Icons.category, color: Colors.teal.shade700),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Date picker row inside a card
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                shadowColor: Colors.teal.shade200,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading:
                      Icon(Icons.calendar_today, color: Colors.teal.shade700),
                  title: Text(
                    'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                    style: GoogleFonts.poppins(
                      color: Colors.teal.shade900,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: _pickDate,
                    child: Text(
                      'Choose Date',
                      style: GoogleFonts.poppins(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Update button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: Colors.teal.shade200,
                  ),
                  child: Text(
                    'Update Expense',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
