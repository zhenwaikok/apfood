import 'package:apfood/vendors/viewmodel/profileVM.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color(0XFF003B73),
              title: const Text(
                "Change Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://static.vecteezy.com/system/resources/previews/020/897/432/original/change-password-regularly-concept-illustration-flat-design-eps10-modern-graphic-element-for-landing-page-empty-state-ui-infographic-icon-vector.jpg",
                          height: 250,
                          width: 250,
                          fit: BoxFit.cover,
                        ),

                        const Text(
                          "Change your password here.",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(
                          height: 50,
                        ),

                        //old password text field
                        TextFormField(
                          controller: viewModel.oldPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                )),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            labelText: "Old Password",
                          ),
                          validator: (String? value) {
                            if (value == null || value.length < 6) {
                              return "Password must be at least 6 characters long.";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        //new password text field
                        TextFormField(
                          controller: viewModel.newPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                )),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            labelText: "New Password",
                          ),
                          validator: (String? value) {
                            if (value == null || value.length < 6) {
                              return "Password must be at least 6 characters long.";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 60,
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFF003B73),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool success = await viewModel.changePassword(
                                    viewModel.user!.email,
                                    viewModel.oldPasswordController.text,
                                    viewModel.newPasswordController.text);

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Successfully changed password!")),
                                  );

                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Failed to change, old password is incorrect!")),
                                  );
                                }
                              }
                            },
                            child: const Text(
                              "Change",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
