import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({required this.onTap, super.key});

  final void Function()? onTap;

  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = "";
  var _enteredUsername = "";
  var _enteredPassword = "";
  final _passwordController = TextEditingController();
  final _defaultProfileImage =
      "https://firebasestorage.googleapis.com/v0/b/apfood-ordering-app.appspot.com/o/ProfileImage%2Fdefault_profile.jpg?alt=media&token=bd61a4b3-5f9a-4915-8b14-322aa6d17be3";

  final List<String> _rolesOption = ["Student", "Vendor", "Admin"];
  var _selectedRole = "Student";

  var _isLoading = false;

  void _signUp() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });

      final userInformation = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);

      FirebaseFirestore.instance
          .collection("users")
          .doc(userInformation.user!.uid)
          .set({
        "username": _enteredUsername,
        "email": _enteredEmail,
        "role": _selectedRole,
        "image_url": _defaultProfileImage,
        "userId": userInformation.user!.uid,
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? "Authentication failed!")));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "Images/APFood.png",
                      width: 280,
                      height: 280,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign Up",
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
                          "Create Your Account and Start Ordering Delicious Food!",
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            DropdownButtonFormField(
                              dropdownColor: Colors.white,
                              value: _selectedRole,
                              decoration: InputDecoration(
                                labelText: "Select Role",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 59, 115),
                                  ),
                                ),
                                floatingLabelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                              items: _rolesOption.map(
                                (value) {
                                  return DropdownMenuItem(
                                      value: value, child: Text(value));
                                },
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
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
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              cursorColor:
                                  const Color.fromARGB(255, 0, 59, 115),
                              decoration: InputDecoration(
                                labelText: (_selectedRole == "Student")
                                    ? "TP Number"
                                    : (_selectedRole == "Vendor")
                                        ? "Vendor Name"
                                        : "Username",
                                suffixIcon: const Icon(Icons.person_outlined),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 59, 115),
                                  ),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (_selectedRole == "Student") {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.trim().length < 6 ||
                                      !value.trim().contains("TP")) {
                                    return "Invalid TP Number";
                                  }
                                } else {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.trim().length < 6) {
                                    return "Name must be at least 6 characters";
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              cursorColor:
                                  const Color.fromARGB(255, 0, 59, 115),
                              controller: _passwordController,
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
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.trim().length < 6) {
                                  return "Password must be at least 6 characters long.";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              cursorColor:
                                  const Color.fromARGB(255, 0, 59, 115),
                              decoration: const InputDecoration(
                                labelText: "Confirm Password",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 59, 115),
                                  ),
                                ),
                              ),
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return "Please ensure the confirmation password matches the entered password.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF003B73),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                ),
                                onPressed: _isLoading == true ? null : _signUp,
                                child: _isLoading == true
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const Text("Sign Up"),
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  _isLoading == true ? null : widget.onTap,
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'Login here',
                                      style: TextStyle(
                                        color: Color(0xFF003B73),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
