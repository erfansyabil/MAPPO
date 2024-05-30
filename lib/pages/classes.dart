import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Restaurant {
  final String id;
  final String name;
  final String address;
  final String foodType;
  final String restaurantType;
  final String imageUrl; // Updated field name to imageUrl
  final String rate;
  final String rating;
  List<Review> reviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.foodType,
    required this.restaurantType,
    required this.imageUrl, // Updated field name to imageUrl
    required this.rate,
    required this.rating,
    this.reviews = const [],
  });

  // Method to retrieve download URL for the image
  Future<String> getImageDownloadUrl() async {
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);
    return await ref.getDownloadURL();
  }

  // Factory constructor to create Restaurant object from Firestore document
  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Restaurant(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      foodType: data['foodType'] ?? '',
      restaurantType: data['restaurantType'] ?? '',
      imageUrl: data['image'] ?? '',// Updated field name to imageUrl
      rate: data['rate'] ?? '',
      rating: data['rating'] ?? '',
    );
  }
}

class Review {
  final String reviewerName;
  final String comment;
  final double rating;
  final DateTime timestamp;

  Review({
    required this.reviewerName,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Review(
      reviewerName: data['reviewerName'] ?? '',
      comment: data['comment'] ?? '',
      rating: data['rating'].toDouble() ?? 0.0,
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate() : DateTime.now(),
    );
  }
}