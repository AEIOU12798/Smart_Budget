import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smart_budget/db/dbHelper.dart';
import 'package:smart_budget/model/modalClass.dart';
import 'package:smart_budget/userDetail/currency_symbol.dart';

class Username extends StatefulWidget {
  final UserModel? user;

  const Username({super.key, this.user});

  @override
  State<Username> createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  final _formKey = GlobalKey<FormState>(); // Key for Form widget
  final _nameController =
      TextEditingController(); // Controller for TextFormField

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Form(
          key: _formKey, // Assign the key to the Form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Add Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Choose A Name For Your Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name', // Add hint text
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            Colors.orange, // Border color for non-focused state
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff106e70), // Yellow border when enabled
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff106e70), // Yellow border when focused
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (_nameController == null ||
                        _nameController.text.isEmpty) {
                      return 'Please enter your name'; // Validation message
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    UserModel user = UserModel(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: _nameController.text,
                    );

                    await DbHelper.instance.insertUserDetail(user);
                    moveToCurrencyPage(); // Call function only if validation passes
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
                      "Next",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void moveToCurrencyPage() {
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: Currency(name: _nameController.text),
        ));
  }
}
