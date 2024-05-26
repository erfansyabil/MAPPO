import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Reviews'),
        ),
        body: const Center(
          child: Text('No user signed in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('restaurants').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading restaurants: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reviews yet.'));
          } else {
            List<Widget> userReviews = [];
            for (var restaurantDoc in snapshot.data!.docs) {
              userReviews.add(
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('restaurants')
                      .doc(restaurantDoc.id)
                      .collection('reviews')
                      .where('userId', isEqualTo: user.uid)
                      .get(),
                  builder: (context, reviewSnapshot) {
                    if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (reviewSnapshot.hasError) {
                      return Center(child: Text('Error loading reviews: ${reviewSnapshot.error}'));
                    } else if (!reviewSnapshot.hasData || reviewSnapshot.data!.docs.isEmpty) {
                      return const SizedBox(); // No reviews for this restaurant by the user
                    } else {
                      return Column(
                        children: reviewSnapshot.data!.docs.map((reviewDoc) {
                          final data = reviewDoc.data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text(data['reviewerName'] ?? 'Anonymous'),
                            subtitle: Text(data['comment'] ?? ''),
                            trailing: Text('${data['rating'] ?? 0} ★'),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              );
            }
            return ListView(
              children: userReviews,
            );
          }
        },
      ),
    );
  }
}
