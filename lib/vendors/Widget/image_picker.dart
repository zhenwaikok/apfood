import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget(
      {required this.onPickImage,
      required this.isLoading,
      this.initialImageUrl,
      super.key});

  final void Function(File pickedImage) onPickImage;
  final bool isLoading;
  final String? initialImageUrl;

  @override
  State<ImagePickerWidget> createState() {
    return _ImagePickerWidgetState();
  }
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _pickedImageFile;

  void _pickImageFromCamera() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 25);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  void _pickImageFromGallery() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 300,
          // if image is picked from the image picker, show the image
          child: _pickedImageFile != null
              ? Image.file(
                  _pickedImageFile!,
                  fit: BoxFit.cover,
                )
              // if image is not picked yet, show their current image (for edit category and item)
              : widget.initialImageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: widget.initialImageUrl!,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  // show image placeholder as default image
                  : Image.asset(
                      "Images/image_placeholder.jpg",
                      fit: BoxFit.cover,
                    ),
        ),
        const SizedBox(
          height: 8,
        ),
        // SizedBox(
        //   width: double.infinity,
        //   child: ElevatedButton(
        //     onPressed: () {
        //       showDialog(
        //         context: context,
        //         builder: (context) => AlertDialog(
        //           backgroundColor: Colors.white,
        //           shape: const RoundedRectangleBorder(
        //             borderRadius: BorderRadius.all(
        //               Radius.circular(5),
        //             ),
        //           ),
        //           title: const Text("Choose Option"),
        //           content: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               ListTile(
        //                 onTap: () {
        //                   Navigator.pop(context);
        //                   _pickImageFromCamera();
        //                 },
        //                 leading: const Icon(Icons.camera_alt),
        //                 title: const Text("Camera"),
        //               ),
        //               ListTile(
        //                 onTap: () {
        //                   Navigator.pop(context);
        //                   _pickImageFromGallery();
        //                 },
        //                 leading: const Icon(Icons.image),
        //                 title: const Text("Gallery"),
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //     },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: const Color.fromARGB(255, 0, 59, 115),
        //       foregroundColor: Colors.white,
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(6),
        //         ),
        //       ),
        //     ),
        //     child: const Text("Select Image"),
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _pickImageFromGallery,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 59, 115),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                child: const Icon(Icons.image),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _pickImageFromCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 59, 115),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
