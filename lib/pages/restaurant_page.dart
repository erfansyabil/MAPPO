import 'package:flutter/material.dart';
import 'package:mappo/common/color_extension.dart';
import 'package:mappo/pages/restaurant.dart';

class RestaurantPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantPage({Key? key, required this.restaurant}) : super(key: key);

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
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: TColor.primary, // Set the border color
                    width: 2.0, // Set the border width
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Optional: make the border rounded
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Clip the image to match the rounded border
                  child: Image.asset(
                    restaurant.image,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
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
              // Add more details or user reviews here
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
