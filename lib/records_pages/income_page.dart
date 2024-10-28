import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_budget/db/dbHelper.dart';
import 'package:smart_budget/model/modalClass.dart';
import 'package:smart_budget/records_pages/expense_page.dart';
import 'package:smart_budget/ui/screens/home_page.dart';

class IncomePage extends StatefulWidget {
  final String balance;
  final String currencySymbol;
  final String name;
  final RecordsModel? recordsModel;

  const IncomePage(
      {super.key,
      this.recordsModel,
      required this.balance,
      required this.name,
      required this.currencySymbol});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _initialBalance = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _memoController = TextEditingController();
  String? _selectedCategory;

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

    if (widget.recordsModel == null) {
      _amountController = TextEditingController();
      _descriptionController = TextEditingController();
      _initialBalance.text = widget.balance.toString();
      _dateController.text = formattedDate;
      _memoController = TextEditingController();
      _selectedCategory = null;
    } else {
      _initialBalance = TextEditingController(text: widget.balance.toString());
      _dateController = TextEditingController(text: widget.recordsModel!.date);
      _descriptionController =
          TextEditingController(text: widget.recordsModel!.description);
      _amountController =
          TextEditingController(text: widget.recordsModel!.amount.toString());
      _memoController =
          TextEditingController(text: widget.recordsModel!.description);
      _selectedCategory = _categories.contains(widget.recordsModel!.category)
          ? widget.recordsModel!.category
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recordsModel == null ? 'Add Income' : 'Update Income',
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
                widget.recordsModel == null ? 'Save' : 'Update',
                style: const TextStyle(color: Colors.white),
              )),
              onTap: () async {
                if (!formKey.currentState!.validate()) return;
                RecordsModel record;
                if (widget.recordsModel == null) {
                  record = RecordsModel(
                    id: DateTime.now().millisecondsSinceEpoch,
                    category: _selectedCategory!,
                    description: _descriptionController.text.trim(),
                    amount:
                        double.parse(_amountController.text.trim().toString()),
                    memo: _memoController.text.trim(),
                    date: _dateController.text.trim(),
                    type: 'Income',
                  );
                  await DbHelper.instance.insert(record);
                } else {
                  record = RecordsModel(
                    id: widget.recordsModel!.id,
                    category: _selectedCategory!,
                    description: _descriptionController.text.trim(),
                    amount:
                        double.parse(_amountController.text.trim().toString()),
                    memo: _memoController.text.trim(),
                    date: _dateController.text.trim(),
                    type: 'Income',
                  );
                  await DbHelper.instance.update(record);
                }

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              initialAmount: widget.balance,
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
                  child: Container(
                    color: Colors.orange,
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
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpensePage(
                            Balance: widget.balance,
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
                      /// Date picker text field with suffix icon
                      TextField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Date",
                            labelStyle: TextStyle(fontSize: 25.0),
                            //border: const OutlineInputBorder(),
                          ),
                          onTap: () => {}
                          //_selectDate(context), // Open date picker on tap
                          ),
                      const SizedBox(height: 30),

                      /// Amount text field
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          labelStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Rs. 0',
                        ),
                      ),
                      const SizedBox(height: 30),

                      /// Description text field
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(fontSize: 18.0),
                          hintText: 'Short Description',
                          hintStyle: TextStyle(color: Colors.black26),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Category dropdown

                      DropdownButtonFormField<String>(
                        borderRadius: BorderRadius.circular(30.0),
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
                        // Placeholder text
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 30),

                      /// Wallet text field

                      TextField(
                        controller: _initialBalance,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Wallet',
                          labelStyle: const TextStyle(fontSize: 25.0),
                          hintText:
                              'Cash . ${widget.currencySymbol} ${widget.balance}',
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),

                      /// Memo textField
                      TextField(
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
