import 'package:flutter/material.dart';
import 'package:mappo/common/color_extension.dart';
import 'package:mappo/pages/classes.dart';

class PopularRestaurantRow extends StatelessWidget {
  final Restaurant pObj;
  final VoidCallback onTap;

  const PopularRestaurantRow({super.key, required this.pObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              pObj.imageUrl, // Use the imageUrl field from the Restaurant object
              width: double.maxFinite,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pObj.name,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 18,
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
                        pObj.rate,
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "(${pObj.rating} Ratings)",
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        pObj.restaurantType,
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        " · ",
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        pObj.foodType,
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
