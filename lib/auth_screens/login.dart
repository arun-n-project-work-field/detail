import 'package:pupil/Auth_Screens/LoginWithAccount.dart';
import 'package:pupil/Auth_Screens/LoginWithPhoneScreen.dart';
import 'package:pupil/Screens/DashboardScreen.dart';
import 'package:pupil/Screens/test.dart';
import 'package:pupil/Widgets/Buttons/RoundButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Widgets/Messages/ToastMessage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;

  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Image.asset(
                    'Assets/Images/LoginImage.png',
                    width: 100,
                    height: 100,
                  ),
                  const Text(
                    "Login to Your Account",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  RoundButton(
                      title: "Login using your Phone Number",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginWithPhoneScreen()));
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Text("or"),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  RoundButton(
                      title: "Login using your Google Account",
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GoogleSignInScreen()));
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
