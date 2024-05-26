import 'review.dart';

class Restaurant {
  final String id;
  final String name;
  final String address;
  final String foodType;
  final String restaurantType;
  final String image;
  final String rate;
  final String rating;
  List<Review> reviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.foodType,
    required this.restaurantType,
    required this.image,
    required this.rate,
    required this.rating,
    this.reviews = const [],
  });
}
