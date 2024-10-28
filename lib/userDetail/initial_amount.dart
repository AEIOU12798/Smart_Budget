import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smart_budget/db/dbHelper.dart';
import 'package:smart_budget/model/modalClass.dart';
import 'package:smart_budget/ui/screens/home_page.dart';

class InitailAmount extends StatefulWidget {
  final String currencySymbol;
  final String name;

  const InitailAmount({
    super.key,
    required this.currencySymbol,
    required this.name,
  });

  @override
  State<InitailAmount> createState() => _InitailAmountState();
}

class _InitailAmountState extends State<InitailAmount> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //String? name=widget.name;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Initial Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "How much money do you have in your\n cashwallet?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  // Accept only numeric input
                  decoration: InputDecoration(
                    hintText: 'Enter amount in ${widget.currencySymbol}',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff106e70),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff106e70),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff106e70),
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    InitialBalanceModel initialbalance = InitialBalanceModel(
                      id: DateTime.now().millisecondsSinceEpoch,
                      balance: double.parse(_amountController.text.toString()),
                    );

                    // Correct usage of the insertInitialAmount method
                    await DbHelper.instance.insertInitialAmount(initialbalance);

                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: HomePage(
                          initialAmount: _amountController.text,
                          name: widget.name,
                          currencySymbol: widget.currencySymbol,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 60,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xff106e70),
                  ),
                  child: const Center(
                    child: Text(
                      "Finish",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              InkWell(
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              initialAmount: '0',
                              name: widget.name,
                              currencySymbol: widget.currencySymbol,
                            )),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
