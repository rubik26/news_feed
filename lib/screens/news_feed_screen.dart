import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/screens/add_new_screen.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void addNew() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddNewScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Feed'),
        actions: [
          IconButton(
            onPressed: addNew,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('news').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> newsSnapshot) {
          if (newsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!newsSnapshot.hasData || newsSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No news found'));
          }
          final newsDocs = newsSnapshot.data!.docs;
          return ListView.builder(
            itemCount: newsDocs.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text(newsDocs[index]['title']),
                subtitle: Text(newsDocs[index]['content']),
                leading: newsDocs[index]['imageUrl'] != null
                    ? Image.network(newsDocs[index]['imageUrl'])
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
