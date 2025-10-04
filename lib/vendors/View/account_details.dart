import 'package:apfood/vendors/viewmodel/profileVM.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final _formKey = GlobalKey<FormState>();

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Account Details",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
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
              backgroundColor: const Color(0XFF003B73),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: viewModel.image != null
                                ? FileImage(viewModel.image!)
                                : NetworkImage(viewModel.user!.image_url)
                                    as ImageProvider,
                          ),
                          Positioned(
                            bottom: -1,
                            left: 90,
                            child: Container(
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        viewModel.pickImage();
                                      },
                                icon: const Icon(Icons.add_a_photo),
                                iconSize: 25,
                                color: const Color.fromARGB(255, 105, 105, 105),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      //email
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Email:",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 43,
                          ),
                          Expanded(
                            child: Text(
                              viewModel.user!.email,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      //TP No
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Name:",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 43,
                          ),
                          Expanded(
                            child: Text(
                              viewModel.user!.username,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      //Role
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Role:",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 65,
                          ),
                          Expanded(
                            child: Text(
                              viewModel.user!.role,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 50,
                      ),

                      //save button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003B73),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  //check if user upload picture
                                  if (viewModel.image != null) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await viewModel.saveProfilePic();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Profile picture updated.")),
                                    );

                                    Navigator.pop(context, true);
                                  }

                                  //check if no image uploaded
                                  else if (viewModel.image == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("No changes made.")),
                                    );

                                    Navigator.pop(context);
                                  }
                                },
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                      ),
                    ],
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
