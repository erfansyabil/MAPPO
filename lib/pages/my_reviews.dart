import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyReviewPage extends StatefulWidget {
  final String userId;

  const MyReviewPage({super.key, required this.userId});

  @override
  State<MyReviewPage> createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .where('reviews', arrayContains: {'reviewerName': widget.userId})
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reviews found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var reviewData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(reviewData['comment'] ?? ''),
                subtitle: Text('Rating: ${reviewData['rating']}'),
                // Additional details of the review can be displayed here
              );
            },
          );
        },
      ),
    );
  }
}
