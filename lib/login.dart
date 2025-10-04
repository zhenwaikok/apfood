import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.onTap, super.key});

  final void Function()? onTap;

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = "";
  var _enteredPassword = "";

  var _isLoading = false;

  void _login() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);
              
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect email or password!")));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 150,
                    color: const Color(0xFF003B73),
                  ),
                  Container(
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //logo
                    Image.asset(
                      "Images/APFood.png",
                      width: 280,
                      height: 280,
                    ),

                    //login text and description
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter your email address and password to log in.",
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),

                    //emaill and pwd text field
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                cursorColor:
                                    const Color.fromARGB(255, 0, 59, 115),
                                decoration: const InputDecoration(
                                  labelText: "Email Address",
                                  suffixIcon: Icon(Icons.mail_outline),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 59, 115),
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains("@") ||
                                      !value.contains(".com")) {
                                    return "Please enter a valid email address!";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredEmail = value!;
                                },
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                cursorColor:
                                    const Color.fromARGB(255, 0, 59, 115),
                                decoration: const InputDecoration(
                                  labelText: "Password",
                                  suffixIcon: Icon(Icons.lock_outlined),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 59, 115),
                                    ),
                                  ),
                                ),
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter password.";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPassword = value!;
                                },
                              ),
                              const SizedBox(height: 50),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF003B73),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(16),
                                    ),
                                    onPressed: _login,
                                    child: const Text("Log In")),
                              ),
                              TextButton(
                                onPressed: _isLoading ? null : widget.onTap,
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Doesn't have an account? ",
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: "Sign Up",
                                        style: TextStyle(
                                          color: Color(0xFF003B73),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
