import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteRestaurantPage extends StatefulWidget {
  const DeleteRestaurantPage({Key? key}) : super(key: key);

  @override
  _DeleteRestaurantPageState createState() => _DeleteRestaurantPageState();
}

class _DeleteRestaurantPageState extends State<DeleteRestaurantPage> {
  final TextEditingController _idController = TextEditingController();

  Future<void> deleteRestaurant(String restaurantId) async {
    try {
      await FirebaseFirestore.instance.collection('restaurants').doc(restaurantId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Restaurant deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting restaurant: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delete Restaurant')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'Restaurant ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String restaurantId = _idController.text;
                deleteRestaurant(restaurantId);
              },
              child: Text('Delete Restaurant'),
            ),
          ],
        ),
      ),
    );
  }
}
