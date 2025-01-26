import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/widgets/image_picker.dart';

class AddNewScreen extends StatefulWidget {
  const AddNewScreen({super.key});

  @override
  State<AddNewScreen> createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _enteredTitle;
  String? _enteredContent;
  bool _isSending = false;
  File? _selectedImage;

  Future<void> _submit(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || _selectedImage == null) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Please enter correct values'),
            content: const Text(
                'Please enter a correct title, content and pick an image if needed'),
          );
        },
      );
    }

    _formKey.currentState!.save();

    setState(() {
      _isSending = true;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('news_images')
          .child('${DateTime.now().toIso8601String()}.jpg');

      await storageRef.putFile(_selectedImage!);

      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('news').add({
        'title': _enteredTitle,
        'content': _enteredContent,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
      });

      setState(() {
        _isSending = false;
      });

      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        _isSending = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('An error occurred'),
            content:
                const Text('Something went wrong. Please try again later.'),
          );
        },
      );
    }
  }

  void _pickImage(File pickedImage) {
    _selectedImage = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredTitle = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        hintText: 'Введите текст поста...',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(),
                      ),
                      textAlign: TextAlign.start,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите текст';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredContent = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ImagePickerWidget(onPickImage: _pickImage),
                  const SizedBox(height: 16),
                  if (_isSending) CircularProgressIndicator(),
                  if (!_isSending)
                    ElevatedButton(
                      onPressed: () => _submit(context),
                      child: const Text('Submit'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
