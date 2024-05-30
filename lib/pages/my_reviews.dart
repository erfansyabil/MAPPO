import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mappo/pages/restaurant_page.dart';
import 'package:mappo/pages/classes.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({super.key});

Future<List<Restaurant>> _getReviewedRestaurants() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is logged in.');
      return [];
    }

    QuerySnapshot restaurantSnapshot = await FirebaseFirestore.instance.collection('restaurants').get();
    List<Restaurant> reviewedRestaurants = [];

    for (var restaurantDoc in restaurantSnapshot.docs) {
      DocumentReference restaurantRef = restaurantDoc.reference;
      QuerySnapshot reviewSnapshot = await restaurantRef.collection('reviews').where('userId', isEqualTo: user.uid).get();
      
      if (reviewSnapshot.docs.isNotEmpty) {
        Restaurant restaurant = Restaurant.fromFirestore(restaurantDoc);
        reviewedRestaurants.add(restaurant);
      }
    }

    print('Total Restaurants Reviewed: ${reviewedRestaurants.length}'); // Debug print

    return reviewedRestaurants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Reviews',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: _getReviewedRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading reviews: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reviews yet.'));
          } else {
            List<Restaurant> restaurants = snapshot.data!;
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                Restaurant restaurant = restaurants[index];
                return ListTile(
                  title: Text(restaurant.name),
                  subtitle: Text('Rating: ${restaurant.rating} ★'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantPage(restaurant: restaurant),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}