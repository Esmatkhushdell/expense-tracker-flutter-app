import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExpenseTrackerHomePage(),
    );
  }
}

class ExpenseTrackerHomePage extends StatefulWidget {
  const ExpenseTrackerHomePage({super.key});

  @override
  _ExpenseTrackerHomePageState createState() => _ExpenseTrackerHomePageState();
}

class _ExpenseTrackerHomePageState extends State<ExpenseTrackerHomePage> {
  final List<Map<String, dynamic>> _expenses = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _addExpense(String title, double amount) {
    setState(() {
      _expenses.add({'title': title, 'amount': amount});
    });
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _titleController.clear();
                _amountController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String title = _titleController.text;
                final double? amount = double.tryParse(_amountController.text);
                if (title.isNotEmpty && amount != null) {
                  _addExpense(title, amount);
                  _titleController.clear();
                  _amountController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_expenses[index]['title']),
                  onDismissed: (direction) {
                    String removedItem = _expenses[index]['title'];
                    _deleteExpense(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$removedItem deleted'),
                      ),
                    );
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text(_expenses[index]['title']),
                    trailing: Text(
                        '\$${_expenses[index]['amount'].toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
