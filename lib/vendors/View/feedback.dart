import 'package:apfood/vendors/viewmodel/feedbackVM.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => FeedbackViewModel(),
        child: Consumer<FeedbackViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: const Color(0XFF003B73),
                title: const Text(
                  "Feedback",
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
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      //image
                      Image.network(
                        'https://img.freepik.com/premium-vector/customer-feedback-user-experience-client-satisfaction-opinion-product-services-review-rating_566886-6141.jpg?w=996',
                        width: double.infinity,
                        height: 260,
                      ),

                      //feedback text
                      const Text(
                        "We always value your feedback.",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(
                        height: 50,
                      ),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Feedback type:",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            //drop down menu
                            Container(
                              width: double.infinity,
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  )),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: viewModel.dropDownSelectedValue,
                                    items: viewModel.dropDownItems
                                        .map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        viewModel.setSelectedValue(value);
                                      }
                                    }),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            const Text(
                              "Your comments:",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            //text field
                            TextFormField(
                              minLines: 3,
                              maxLines: null,
                              controller: viewModel.feedback,
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
                                      horizontal: 10, vertical: 10)),
                            ),

                            const SizedBox(
                              height: 60,
                            ),
                          ]),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF003B73),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {
                            viewModel.saveFeedback(context);
                          },
                          child: const Text(
                            "Submit",
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
            );
          },
        ));
  }
}
