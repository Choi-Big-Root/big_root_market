import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class CameraExample extends StatefulWidget {
  const CameraExample({super.key});

  @override
  State<CameraExample> createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  XFile? imageFile;
  late CameraController controller;

  Future<XFile?> takeCameraPicture() async {
    final CameraController cameraController = controller;
    if (!cameraController.value.isInitialized) {
      debugPrint('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller
        .initialize()
        .then((_) {
          if (!context.mounted) return;
          setState(() {});
        })
        .catchError((e) {
          if (e == CameraException) {
            debugPrint(e.toString());
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Example')),
      body: Column(
        children: [
          Expanded(
            child:
                controller.value.isInitialized
                    ? CameraPreview(controller)
                    : const Text('초기화중...'),
          ),

          IconButton(
            onPressed: () {
              takeCameraPicture().then((XFile? file) {
                if (!mounted) return; // 먼저 체크!

                setState(() {
                  imageFile = file;
                });
                if (file != null) {
                  debugPrint(file.toString());
                  debugPrint(file.path);
                }
              });
            },
            icon: const Icon(Icons.camera),
            iconSize: 60,
          ),
        ],
      ),
    );
  }
}
