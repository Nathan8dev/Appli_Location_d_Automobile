import 'package:flutter/material.dart';

class ImagesFond extends StatelessWidget {
  final String backgroundImagePath;
  final Widget child;

  const ImagesFond({
    super.key,
    required this.backgroundImagePath,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImagePath),
          fit: BoxFit.cover, // Assure que l'image couvre tout l'espace
        ),
      ),
      child: child,
    );
  }
}