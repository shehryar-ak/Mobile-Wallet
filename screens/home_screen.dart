import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_money.dart';
import 'saved_money_track.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _showButtons = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showButtons = true;
      });
    });
  }

  Future<void> _confirmLogout() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Do you really want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f7),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          'Money Tracker Dashboard',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _confirmLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'Track your money\nEffortlessly!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.teal.shade800,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Manage your spending,\nSave smarter.',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 60),
            AnimatedOpacity(
              opacity: _showButtons ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddExpenseScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline, size: 26),
                    label: const Text("+ Add Money"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal.shade600,
                      elevation: 10,
                      shadowColor: Colors.teal.shade200,
                      minimumSize: const Size(double.infinity, 55),
                      textStyle: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedExpensesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history, size: 26),
                    label: const Text("View Spending History"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.teal.shade700,
                      backgroundColor: Colors.white,
                      elevation: 5,
                      side: BorderSide(color: Colors.teal.shade400, width: 1.5),
                      minimumSize: const Size(double.infinity, 55),
                      textStyle: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
