import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerImageWidget extends StatelessWidget {
  const ShimmerImageWidget(
      {required this.imageURL,
      required this.height,
      required this.width,
      super.key});

  final String imageURL;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageURL,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
        imageBuilder: (context, imageProvider) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fitWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}
