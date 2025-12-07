import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    // 🚧 TODO: Person 2 will implement the ListView here
    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3), // Semi-transparent background
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueAccent, width: 2),
      ),
      child: const Center(
        child: Text(
          "🚧 Person 2 Area\n(Category List & Images)",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}