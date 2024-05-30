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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Home Page"),
      ),
      drawer: const NavBarAdmin(),
      body: SingleChildScrollView(
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
                  title: "Popular Restaurants",
                  onView: () {},
                ),
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  :ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: popArr.length,
                itemBuilder: ((context, index) {
                  var pObj = popArr[index];
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
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
