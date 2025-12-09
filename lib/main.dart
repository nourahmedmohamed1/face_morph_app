import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'widgets/camera_view.dart'; // هنشغل الكاميرا علطول عشان ننجز

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ⚠️ التغيير هنا: شيلنا كلمة const من قبل MaterialApp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraView(), // هنفتح الكاميرا علطول بدل Home Screen عشان نشوف المربع الأحمر
    );
  }
}