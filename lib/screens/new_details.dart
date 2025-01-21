import 'package:flutter/material.dart';

class NewDetails extends StatelessWidget {
  const NewDetails(
      {super.key,
      required this.title,
      required this.content,
      required this.imageUrl});

  final String title;
  final String content;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.network(
                imageUrl,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(content),
            ),
          ],
        ),
      ),
    );
  }
}
