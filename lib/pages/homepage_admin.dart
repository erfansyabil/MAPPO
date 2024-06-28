import 'package:flutter/material.dart';
import 'navbar_admin.dart';
import 'package:mappo/common_widget/round_textfield.dart';
import 'package:mappo/common_widget/popular_restaurant_row.dart';
import 'package:mappo/common_widget/view_all_title_row.dart';
import 'package:mappo/pages/classes.dart';
import 'package:mappo/pages/restaurant_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  TextEditingController txtSearch = TextEditingController();

  List<Restaurant> popArr = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  void _fetchRestaurants() {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance.collection('restaurants').get().then((snapshot) {
      setState(() {
        popArr = snapshot.docs.map((doc) => Restaurant.fromFirestore(doc)).toList();
        isLoading = false;
      });
    }).catchError((error) {
      debugPrint('Error fetching restaurants: $error');
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<Map<String, dynamic>> _fetchRatings(String restaurantId) async {
    QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantId)
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Home Page"),
      ),
      drawer: const NavBarAdmin(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RoundTextfield(
                      hintText: "Search Food",
                      controller: txtSearch,
                      left: Container(
                        alignment: Alignment.center,
                        width: 30,
                        child: Image.asset(
                          "assets/img/search.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ViewAllTitleRow(
                      title: "Available Restaurants",
                      onView: () {},
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: popArr.length,
                    itemBuilder: ((context, index) {
                      var pObj = popArr[index];
                      return FutureBuilder<Map<String, dynamic>>(
                        future: _fetchRatings(pObj.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return PopularRestaurantRow(
                              pObj: pObj,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RestaurantPage(restaurant: pObj),
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return PopularRestaurantRow(
                              pObj: pObj,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RestaurantPage(restaurant: pObj),
                                  ),
                                );
                              },
                            );
                          } else {
                            double averageRating = snapshot.data?['averageRating'] ?? 0.0;
                            int totalReviews = snapshot.data?['totalReviews'] ?? 0;

                            return PopularRestaurantRow(
                              pObj: pObj,
                              averageRating: averageRating,
                              totalReviews: totalReviews,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RestaurantPage(restaurant: pObj),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}