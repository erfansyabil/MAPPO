import 'package:flutter/material.dart';
import 'navbar_admin.dart';
import 'package:mappo/common/color_extension.dart';
import 'package:mappo/common_widget/round_textfield.dart';
import '../../common_widget/popular_resutaurant_row.dart';
import '../../common_widget/view_all_title_row.dart';
import 'restaurant_page.dart';
import 'package:mappo/pages/restaurant.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  TextEditingController txtSearch = TextEditingController();

  List<Restaurant> popArr = [
    Restaurant(
      id: "1",
      name: "Minute by tuk tuk",
      address: "Lorong Haji Taib, Chow Kit, 50350 Kuala Lumpur, Federal Territory of Kuala Lumpur",
      foodType: "Asian Food",
      restaurantType: "Cafe",
      image: "assets/img/res_1.png",
      rate: "4.7",
      rating: "200",
    ),
    Restaurant(
      id: "2",
      name: "Café de Noir",
      address: "Jalan Kebudayaan 38, Taman Universiti, 81300 Skudai, Johor",
      foodType: "Western Food",
      restaurantType: "Cafe",
      image: "assets/img/res_2.png",
      rate: "4.9",
      rating: "104",
    ),
    Restaurant(
      id: "3",
      name: "Bakes by Tella",
      address: "2011, Jln Ismail Sultan, Danga Bay Johor bahru, 80200 Johor",
      foodType: "European Food",
      restaurantType: "Cafe",
      image: "assets/img/res_3.png",
      rate: "4.1",
      rating: "231",
    ),
  ];

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
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivering to",
                      style: TextStyle(color: TColor.secondaryText, fontSize: 11),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Current Location",
                          style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Image.asset(
                          "assets/img/dropdown.png",
                          width: 12,
                          height: 12,
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
              ListView.builder(
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