// الملف: lib/widgets/camera_view.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../main.dart';
import '../painters/face_painter.dart'; // بننده على الرسام اللي عملناه في خطوة 1

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? controller;
  bool isBusy = false; // عشان لو الذكاء لسه بيفكر في صورة ميبعتلوش التانية
  CustomPaint? customPaint; // الطبقة الشفافة اللي هنرسم عليها

  // إعدادات كاشف الوجه
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true, // هات حدود الوش
      enableLandmarks: true, // هات مكان العين والأنف
    ),
  );

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  // 1. تشغيل الكاميرا
  Future<void> initializeCamera() async {
    if (cameras.isEmpty) return;

    // cameras[1] هي الكاميرا الأمامية (Slefie)
    controller = CameraController(cameras[1], ResolutionPreset.high, enableAudio: false);

    await controller!.initialize();
    if (!mounted) return;

    // أهم سطر: ابدأ ابعت صور (Stream)
    controller?.startImageStream(_processImage);
    setState(() {});
  }

  // 2. معالجة كل صورة بتيجي من الكاميرا
  Future<void> _processImage(CameraImage image) async {
    if (isBusy) return;
    isBusy = true;

    // تحويل الصورة لصيغة يفهمها ML Kit
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      isBusy = false;
      return;
    }

    try {
      // شغل الذكاء الاصطناعي
      final faces = await _faceDetector.processImage(inputImage);

      // لو الصورة تمام، انده الرسام يرسم المربعات
      if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
        final painter = FacePainter(
          faces,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
        );
        customPaint = CustomPaint(painter: painter);
      } else {
        customPaint = null;
      }

      if (mounted) setState(() {});

    } catch (e) {
      print("Error: $e");
    }
    isBusy = false;
  }

  @override
  void dispose() {
    _faceDetector.close(); // اقفل الذكاء
    controller?.dispose(); // اقفل الكاميرا
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container(color: Colors.black); // شاشة سوداء لحد ما الكاميرا تفتح
    }

    // عرض الكاميرا وفوقها الرسم
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(controller!),
        if (customPaint != null) customPaint!,
      ],
    );
  }

  // 🛑 كود تقني جداً لتحويل الصور (نسخ ولصق فقط)
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = cameras[1];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;
    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
}