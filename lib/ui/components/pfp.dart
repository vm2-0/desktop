import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';

class Pfp extends StatelessWidget {
  const Pfp({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: const Color.fromARGB(255, 140, 122, 228),
      child: Image.asset(
        Assets.logoWhite,
        width: 18,
        height: 18,
        color: ClonesColors.primaryText,
      ),
    );
  }
}
