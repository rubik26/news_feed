import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, required this.onPickImage});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();

  final void Function(File pickedImage) onPickImage;
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? image;

  void _imagePicker() async {
    final currentImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (currentImage == null) {
      return;
    }

    setState(() {
      image = File(currentImage.path);
    });

    widget.onPickImage(image!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: image != null
              ? Image.file(
                  image!,
                  fit: BoxFit.cover,
                )
              : Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: Center(
                      child: Text('No image selected'),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _imagePicker,
          child: const Text('Pick Image'),
        ),
      ],
    );
  }
}
