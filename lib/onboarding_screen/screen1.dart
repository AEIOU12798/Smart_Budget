import 'package:flutter/material.dart';
import 'package:smart_budget/onboarding_screen/screen2.dart';

class OnBroadingScreen1 extends StatefulWidget {
  const OnBroadingScreen1({super.key});

  @override
  State<OnBroadingScreen1> createState() => _onBroad1State();
}

class _onBroad1State extends State<OnBroadingScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  child: Image.asset(
                    "assets/images/img_1.png",
                  )),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  "Track Your Income and \n expenses effortlessly",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Track Your Transactions automatically \n without syncing your bank account",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: movetonext,
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xff106e70),
                  ),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void movetonext() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnBroadingScreen2(),
        ));
  }
}
