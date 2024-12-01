import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UserRegistrationPage(),
    );
  }
}

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({super.key});

  @override
  _UserRegistrationPageState createState() {
    return _UserRegistrationPageState();
  }
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final List<Map<String, dynamic>> _users = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void _addUser() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final ageText = _ageController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || ageText.isEmpty) {
      _showMessage('All fields are required');
      return;
    }

    bool _isValidEmail(String email) {
      return EmailValidator.validate(email);
    }

    if (!_isValidEmail(email)) {
      _showMessage('Enter a valid email');
      return;
    }

    if (phone.length != 8 || int.tryParse(phone) == null) {
      _showMessage('Enter a valid 8-digit phone number');
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null || age < 1 || age > 120) {
      _showMessage('Enter a valid age');
      return;
    }

    setState(() {
      _users.add({
        'name': name,
        'email': email,
        'phone': phone,
        'age': age,
        'expenses': [],
      });
    });

    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _ageController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Here'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please Enter Your Personal Information:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _addUser,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Add User'),
                ),
              ],
            ),
            const SizedBox(height: 2),
            if (_users.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        title: Text(user['name']),
                        subtitle: Text('Calculate your Expenses here'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ExpenseTrackerPage(user: user);
                                },
                              ),
                            );
                          },
                          child: const Text('Open'),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                child: Text(
                  'No users added yet!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ExpenseTrackerPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const ExpenseTrackerPage({required this.user, super.key});

  @override
  _ExpenseTrackerPageState createState() {
    return _ExpenseTrackerPageState();
  }
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final List<String> _categories = ['Food', 'Transportation', 'Entertainment'];
  String? _selectedCategory;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void _addExpense() {
    final amountText = _amountController.text.trim();
    final salaryText = _salaryController.text.trim();

    if (amountText.isEmpty || _selectedCategory == null || salaryText.isEmpty) {
      _showMessage('All fields are required');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showMessage('Enter a valid amount');
      return;
    }
    final salary = double.tryParse(salaryText);
    if (salary == null || salary <= 0) {
      _showMessage('Enter a valid salary');
      return;
    }


    setState(() {
      widget.user['expenses'].add({
        'amount': amount,
        'category': _selectedCategory,
      });
      widget.user['salary'] = salary;
    });
    _amountController.clear();
    _selectedCategory = null;
  }

  void _addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _newCategoryController =
        TextEditingController();
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: _newCategoryController,
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newCategory = _newCategoryController.text.trim();
                if (newCategory.isNotEmpty) {
                  setState(() {
                    _categories.add(newCategory);
                  });
                }
                Navigator.of(context).pop();
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
    final totalExpense =
    widget.user['expenses'].fold(0.0, (sum, item) => sum + item['amount']);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user['name']}'s Expenses"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add your Expenses:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Salary',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addExpense,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Expenses:',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalExpense.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Remaining Salary:',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${((widget.user['salary'] ?? 0.0) - totalExpense).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: widget.user['expenses'].isEmpty
                  ? const Center(
                child: Text(
                  'No expenses added yet!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: widget.user['expenses'].length,
                itemBuilder: (context, index) {
                  final expense = widget.user['expenses'][index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(expense['category']),
                      trailing: Text(
                        '\$${expense['amount'].toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}