import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/money_storage.dart';
import '../models/money.dart';
import 'edit_money.dart';

class SavedExpensesScreen extends StatefulWidget {
  const SavedExpensesScreen({super.key});

  @override
  State<SavedExpensesScreen> createState() => _SavedExpensesScreenState();
}

class _SavedExpensesScreenState extends State<SavedExpensesScreen> {
  final List<Expense> expenses = ExpenseStorage.expenses;
  String _searchText = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Other'
  ];

  void _deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense deleted')),
    );
  }

  Future<void> _editExpense(int index) async {
    final updatedExpense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpenseScreen(
          index: index,
          expense: expenses[index],
        ),
      ),
    );

    if (updatedExpense != null) {
      setState(() {
        expenses[index] = updatedExpense;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense updated')),
      );
    }
  }

  List<Expense> get _filteredExpenses {
    return expenses.where((expense) {
      final matchesSearch = expense.description
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          expense.amount.toLowerCase().contains(_searchText.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || expense.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          'Saved Expenses',
          style: GoogleFonts.poppins(
            color: Colors.teal.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
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
        child: SafeArea(
          child: Column(
            children: [
              // 🔍 Search Bar
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by amount',
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 🧾 Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((category) => DropdownMenuItem(
                        value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Filter by Category',
                  labelStyle: const TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _filteredExpenses.isEmpty
                    ? Center(
                        child: Text(
                          'No expenses found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = _filteredExpenses[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.teal.shade200),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal.shade700,
                                child: Text(
                                  expense.category[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                '${expense.description} - \$${expense.amount}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.teal.shade900,
                                ),
                              ),
                              subtitle: Text(
                                '${expense.category} • ${expense.date.toLocal().toString().split(' ')[0]}',
                                style: GoogleFonts.poppins(
                                  color: Colors.teal.shade700,
                                ),
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deleteExpense(expenses.indexOf(expense)),
                              ),
                              onTap: () =>
                                  _editExpense(expenses.indexOf(expense)),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
