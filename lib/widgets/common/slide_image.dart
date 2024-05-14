import 'package:flutter/material.dart';

class SlideImage extends StatefulWidget {
  final String image;
  final double width;
  final double height;
  final Animation<Offset> offsetAnimation;
  const SlideImage(
      {super.key,
      required this.image,
      required this.offsetAnimation,
      required this.width,
      required this.height});

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SlideTransition(
          position: widget.offsetAnimation,
          child: Image.asset(
            widget.image,
            width: widget.width,
            height: widget.height,
          )),
    );
  }
}
