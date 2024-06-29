import 'package:flutter/material.dart';
import 'package:mappo/pages/navBar.dart';
import 'package:mappo/common_widget/round_textfield.dart';
import 'package:mappo/common_widget/popular_restaurant_row.dart';
import 'package:mappo/common_widget/view_all_title_row.dart';
import 'package:mappo/pages/classes.dart';
import 'package:mappo/pages/restaurant_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtSearch = TextEditingController();
  List<Restaurant> popArr = [];
  List<Restaurant> filteredArr = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
    txtSearch.addListener(() {
      _filterRestaurants(txtSearch.text);
    });
  }

  void _fetchRestaurants() {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance.collection('restaurants').get().then((snapshot) {
      setState(() {
        popArr = snapshot.docs.map((doc) => Restaurant.fromFirestore(doc)).toList();
        filteredArr = popArr; // Initialize filteredArr with all restaurants
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

  void _filterRestaurants(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredArr = popArr;
      } else {
        filteredArr = popArr.where((restaurant) {
          final nameLower = restaurant.name.toLowerCase();
          final addressLower = restaurant.address.toLowerCase();
          final searchLower = query.toLowerCase();

          return nameLower.contains(searchLower) || addressLower.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      drawer: const NavBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RoundTextfield(
                    hintText: "Search Restaurant",
                    controller: txtSearch,
                    onSubmitted: (query) {
                      _filterRestaurants(query);
                    },
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
                Expanded(
                  child: filteredArr.isEmpty
                      ? const Center(
                          child: Text(
                            'No result',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: filteredArr.length,
                          itemBuilder: (context, index) {
                            var pObj = filteredArr[index];
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
                          },
                        ),
                ),
              ],
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
