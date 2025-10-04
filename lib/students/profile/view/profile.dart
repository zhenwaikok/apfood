import 'package:apfood/profile_row.dart';
import 'package:apfood/students/profile/view/account_details.dart';
import 'package:apfood/students/feedback/view/feedback.dart';
import 'package:apfood/students/orders/view/orders.dart';
import 'package:apfood/students/profile/view/change_password.dart';
import 'package:apfood/students/profile/viewmodel/profileVM.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color(0XFF003B73),
              title: const Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: SizedBox(
                        height: 125,
                        width: 125,
                        child: CachedNetworkImage(
                          imageUrl: viewModel.user!.image_url,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      viewModel.user!.username,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AccountDetailsScreen())).then((_) {
                          viewModel.fetchUserData();
                        });
                      },
                      child: const ProfileRow(
                          icon: Icons.person, text: "Account Details"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FeedbackScreen()));
                      },
                      child: const ProfileRow(
                          icon: Icons.feedback, text: "Feedback"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrdersScreen()));
                      },
                      child: const ProfileRow(
                          icon: Icons.text_snippet_sharp, text: "Orders"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePasswordScreen()));
                        },
                        child: const ProfileRow(
                            icon: Icons.password, text: "Change Password")),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        viewModel.signOut();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout,
                              size: 40, color: Color(0XFF60A3D9)),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child:
                                Text("Logout", style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
