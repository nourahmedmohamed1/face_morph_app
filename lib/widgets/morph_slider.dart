import 'package:flutter/material.dart';

class MorphSlider extends StatelessWidget {
  const MorphSlider({super.key});

  @override
  Widget build(BuildContext context) {
    // 🚧 TODO: Person 2 will implement the Slider here
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.redAccent),
      ),
      child: const Center(
        child: Text(
          "🚧 Person 2 Area (Morph Slider)",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}