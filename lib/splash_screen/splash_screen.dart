import 'package:flutter/material.dart';
import 'package:smart_budget/onboarding_screen/screen1.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageSizeAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller that runs for 4 seconds
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    // Tween to animate the size of the image (starting small and growing)
    _imageSizeAnimation = Tween<double>(begin: 100, end: 300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Tween to animate the opacity of the text
    _fadeAnimation = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(child: child, opacity: animation);
      },
      child: _controller.isCompleted
          ? Icon(Icons.pie_chart, size: 150, key: ValueKey<int>(1))
          : Icon(Icons.account_balance_wallet, size: 150, key: ValueKey<int>(2)),
    );
    _controller.forward();
    // Start the animation


    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBroadingScreen1()), // Your main page
        );
      }
    });
///  onboarding to home page method using sqlite
    // void whereToGo() async {
    //   var SharedPref = await SharedPreferences.getInstance();
    //   var IsLastScreen = SharedPref.getBool(LastOnBoardingScreen);
    //
    //   if (IsLastScreen != null) {
    //     if (IsLastScreen) {
    //       Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => HomePage()));
    //     } else {
    //       Navigator.pushReplacement(context,
    //           MaterialPageRoute(builder: (context) => OnBroadingScreen1()));
    //     }
    //   } else {
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => OnBroadingScreen1()));
    //   }
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image animation: animate the size of the image
                Container(
                  width: _imageSizeAnimation.value,
                  height: _imageSizeAnimation.value,
                  child: Image.asset('assets/images/image_for_splashScreen-removebg-preview.png'), // Replace with your image path
                ),
                SizedBox(height: 20),
                // Fade in the app name text
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    'Finance Management App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff106e70),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
