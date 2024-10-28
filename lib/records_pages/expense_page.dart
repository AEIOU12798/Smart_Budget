import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_budget/db/dbHelper.dart';
import 'package:smart_budget/model/modalClass.dart';
import 'package:smart_budget/records_pages/income_page.dart';
import 'package:smart_budget/ui/screens/home_page.dart';

class ExpensePage extends StatefulWidget {
  final String Balance;
  final String name;
  final String currencySymbol;
  final RecordsModel? recordModel;

  const ExpensePage(
      {super.key,
      this.recordModel,
      required this.Balance,
      required this.name,
      required this.currencySymbol});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _initialBalance = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _memoController = TextEditingController();
  String? _selectedCategory;

  // static const String _type = 'Expense';

  final List<String> _categories = [
    'Bills',
    'Clothing',
    'Education',
    'Entertainment',
    'Fitness',
    'Food',
    'Gifts',
    'Health',
    'Furniture',
    'Pet',
    'Shopping',
    'Transportation',
    'Travel',
    'Others',
  ];
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Automatically set the current date and time when the screen opens
    String formattedDate =
        DateFormat('yyyy-MM-dd    hh:mm a').format(DateTime.now());
    _dateController.text = formattedDate;

    if (widget.recordModel == null) {
      _amountController = TextEditingController();
      _descriptionController = TextEditingController();
      _initialBalance.text = widget.Balance.toString();
      _dateController.text = formattedDate;
      _memoController = TextEditingController();
      _selectedCategory = null;
    } else {
      _initialBalance = TextEditingController(text: widget.Balance);
      _dateController = TextEditingController(text: widget.recordModel!.date);
      _descriptionController =
          TextEditingController(text: widget.recordModel!.description);
      _amountController =
          TextEditingController(text: widget.recordModel!.amount.toString());
      _memoController =
          TextEditingController(text: widget.recordModel!.description);
      _selectedCategory = _categories.contains(widget.recordModel!.category)
          ? widget.recordModel!.category
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recordModel == null ? 'Add Expense' : 'Update Expense',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff106e70),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              child: Center(
                child: Text(
                  widget.recordModel == null ? 'Save' : 'Update',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              onTap: () async {
                if (!formKey.currentState!.validate()) return;
                RecordsModel record;
                if (widget.recordModel == null) {
                  record = RecordsModel(
                    id: DateTime.now().millisecondsSinceEpoch,
                    category: _selectedCategory!,
                    description: _descriptionController.text.trim(),
                    amount:
                        double.parse(_amountController.text.trim().toString()),
                    memo: _memoController.text.trim(),
                    date: _dateController.text.trim(),
                    type: 'Expense',
                  );
                  await DbHelper.instance.insert(record);
                } else {
                  record = RecordsModel(
                    id: widget.recordModel!.id,
                    category: _selectedCategory!,
                    description: _descriptionController.text.trim(),
                    amount:
                        double.parse(_amountController.text.trim().toString()),
                    memo: _memoController.text.trim(),
                    date: _dateController.text.trim(),
                    type: 'Expense',
                  );
                  await DbHelper.instance.update(record);
                }

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              initialAmount: widget.Balance,
                              name: widget.name,
                              currencySymbol: widget.currencySymbol,
                            ))); // Return the updated or new record
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            color: const Color(0xff106e70),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IncomePage(
                            balance: widget.Balance,
                            name: widget.name,
                            currencySymbol: widget.currencySymbol,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: const Color(0xff106e70),
                      child: const Center(
                        child: Text(
                          "Income",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.orange,
                    child: const Center(
                      child: Text(
                        "Expense",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 15, right: 15),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Date field
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Date",
                          labelStyle: TextStyle(fontSize: 25.0),
                        ),
                        onTap: () {
                          // Call your date picker function here
                        },
                      ),
                      const SizedBox(height: 30),
                      // Amount field
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          labelStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Rs. 0',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Short Description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Category dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: "Category",
                          labelStyle: TextStyle(fontSize: 25.0),
                        ),
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        hint: const Text('Select Category'),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      // Wallet field
                      TextFormField(
                        controller: _initialBalance,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Wallet',
                          labelStyle: TextStyle(fontSize: 25.0),
                          hintText:
                              'Cash . ${widget.currencySymbol} ${widget.Balance}',
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Memo field
                      TextFormField(
                        controller: _memoController,
                        decoration: const InputDecoration(
                          labelText: 'Memo',
                          labelStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Add a note',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
