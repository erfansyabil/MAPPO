import 'package:flutter/material.dart';
import 'package:mappo/common/color_extension.dart';
import 'package:mappo/pages/classes.dart';
import 'review_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
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
                            snapshot.data!, // Use the download URL here
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  }
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
              Row(
                children: [
                  Image.asset(
                    "assets/img/rate.png",
                    width: 10,
                    height: 10,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    restaurant.rate,
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "(${restaurant.rating} Ratings)",
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
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.storefront,
                label: 'Type of Restaurant',
                value: restaurant.restaurantType,
              ),
              const SizedBox(height: 16),
              Divider(color: TColor.secondaryText),
              const SizedBox(height: 16),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
              const SizedBox(height: 16),
              Text(
                'Reviews',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(restaurant.id)
                    .collection('reviews')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading reviews: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No reviews yet.');
                  } else {
                    return Column(
                      children: snapshot.data!.docs.map((doc) {
                        Review review = Review.fromFirestore(doc);
                        return ListTile(
                          title: Text(review.reviewerName),
                          subtitle: Text(review.comment),
                          trailing: Text('${review.rating} ★'),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: TColor.primary),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
}
