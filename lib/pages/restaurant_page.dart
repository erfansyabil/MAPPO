import 'package:flutter/material.dart';
import 'package:mappo/common/color_extension.dart';
import 'package:mappo/pages/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'review_page.dart';
import 'package:mappo/pages/update_restaurant.dart';

class RestaurantPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantPage({super.key, required this.restaurant});

  Future<bool> _isAdmin() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
      return userData != null && userData['role'] == 'admin';
    }
    return false;
  }

  Future<Map<String, dynamic>> _fetchRatings() async {
    QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurant.id)
        .collection('reviews')
        .get();

    int totalReviews = reviewSnapshot.docs.length;
    double totalRating = 0.0;

    for (var doc in reviewSnapshot.docs) {
      totalRating += doc['rating'] ?? 0.0;
    }

    double averageRating = totalReviews > 0 ? totalRating / totalReviews : 0.0;

    return {
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurant.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                future: restaurant.getImageDownloadUrl(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading image: ${snapshot.error}');
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: TColor.primary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          snapshot.data!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                restaurant.name,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<Map<String, dynamic>>(
                future: _fetchRatings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading ratings: ${snapshot.error}');
                  } else {
                    double averageRating = snapshot.data?['averageRating'] ?? 0.0;
                    int totalReviews = snapshot.data?['totalReviews'] ?? 0;

                    return Row(
                      children: [
                        Image.asset(
                          "assets/img/rate.png",
                          width: 10,
                          height: 10,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "($totalReviews Ratings)",
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          restaurant.restaurantType,
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          " · ",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          restaurant.foodType,
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Divider(color: TColor.secondaryText),
              const SizedBox(height: 16),
              _buildInfoRow(
                icon: Icons.info_outline,
                label: 'Restaurant ID',
                value: restaurant.id,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.location_on,
                label: 'Address',
                value: restaurant.address,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.restaurant_menu,
                label: 'Type of Food',
                value: restaurant.foodType,
              ),
              const SizedBox(height: 16),
              Divider(color: TColor.secondaryText),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(restaurant: restaurant),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text(
                      'Add Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FutureBuilder<bool>(
                    future: _isAdmin(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const SizedBox(); // Handle error gracefully
                      } else if (snapshot.data == true) {
                        return Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateRestaurantPage(restaurant: restaurant),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                _deleteRestaurant(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox(); // Do not display anything if the user is not admin
                      }
                    },
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Reviews",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(restaurant.id)
                    .collection('reviews')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final reviews = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      final reviewerName = review['reviewerName'] ?? 'Anonymous';
                      final comment = review['comment'];
                      final rating = review['rating'].toString();
                      final timestamp = review['timestamp'] != null
                          ? (review['timestamp'] as Timestamp).toDate()
                          : DateTime.now();
                      final userId = review['userId'];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            reviewerName,
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                comment,
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rating: $rating',
                                style: TextStyle(
                                  color: TColor.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Date: ${DateFormat.yMMMd().format(timestamp)}',
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          trailing: userId == currentUserId || snapshot.data == true
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditReviewDialog(context, review);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteReviewDialog(context, review.id);
                                },
                              ),
                            ],
                          )
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(restaurant: restaurant),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: TColor.primary),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: TColor.primaryText,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: TColor.secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  void _showEditReviewDialog(BuildContext context, DocumentSnapshot review) {
    TextEditingController commentController = TextEditingController(text: review['comment']);
    TextEditingController ratingController = TextEditingController(text: review['rating'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                decoration: const InputDecoration(labelText: 'Comment'),
              ),
              TextField(
                controller: ratingController,
                decoration: const InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(restaurant.id)
                    .collection('reviews')
                    .doc(review.id)
                    .update({
                  'comment': commentController.text,
                  'rating': double.parse(ratingController.text),
                  'timestamp': Timestamp.now(),
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteReviewDialog(BuildContext context, String reviewId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Review'),
          content: const Text('Are you sure you want to delete this review? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(restaurant.id)
                    .collection('reviews')
                    .doc(reviewId)
                    .delete()
                    .then((_) {
                      Navigator.of(context).pop();
                    });
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteRestaurant(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Restaurant'),
          content: const Text('Are you sure you want to delete this restaurant? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(restaurant.id)
                    .delete()
                    .then((_) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(); // Navigate back to the previous screen
                    });
              },
            ),
          ],
        );
      },
    );
  }
}

